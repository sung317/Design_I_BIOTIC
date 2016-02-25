
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <unistd.h>
#include "matrix.h"

#define LN_TO_LOG2 1.44269504088896

/*****************/
struct datafilehead
/*****************/
/* Used at the beginning of each data file (fid's, spectra, 2D)  */
{  
   long    nblocks;       /* number of blocks in file       */
   long    ntraces;       /* number of traces per block        */
   long    np;            /* number of elements per trace      */
   long    ebytes;        /* number of bytes per element    */
   long    tbytes;        /* number of bytes per trace         */
   long    bbytes;        /* number of bytes per block         */
   short   vers_id;       /* software version and file_id status bits   */
   short   status;        /* status of whole file        */
   long    nbheaders;     /* number of block headers        */
};

/*******************/
struct datablockhead
/*******************/
/* Each file block contains the following header        */
{  
   short   scale;    /* scaling factor                   */
   short   status;   /* status of data in block          */
   short   index;    /* block index                      */
   short   mode;     /* mode of data in block       */
   long    ctcount;  /* ct value for FID         */
   float   lpval;    /* F2 left phase in phasefile       */
   float   rpval;    /* F2 right phase in phasefile      */
   float   lvl;      /* F2 level drift correction        */
   float   tlt;      /* F2 tilt drift correction         */
};

static const char *hdrnames[9] =
{
   "nblocks",
   "ntraces",
   "np",
   "ebytes",
   "tbytes",
   "bbytes",
   "vers_id",
   "status",
   "nbheaders"
};

static const char *bhdrnames[9] = 
{
   "scale",
   "status",
   "index",
   "mode",
   "ctcount",
   "lpval",
   "rpval",
   "lvl",
   "tlt"
};

mexFunction(int nlhs, mxArray *plhs[],
      int nrhs, const mxArray *prhs[])
{
   int i, j, nval;
   long m, n, np;
   struct datafilehead  hdr;
   struct datablockhead bhdr;
   double *pReal;
   double *pImag;
   double scale;
   double pfactor;
   void *k;
   short *k_short;
   int *k_int;
   bool cleanup = true;
   bool dp = false;
   bool use_first = false;
   FILE *FID;
   char filename[FILENAME_MAX];
   char filename2[FILENAME_MAX];
   char filename3[FILENAME_MAX];

   // Check the number of arguments
   if (nrhs < 5)
      mexErrMsgTxt("Too few input arguments.");

   if (nrhs > 5)
      cleanup = (bool) mxGetScalar(prhs[5]);
   
   // Get the file name and append /fid.out
   mxGetString(prhs[0], filename, FILENAME_MAX);
   strcat(filename, "/fid.out");
   
   // Open the file for writing with truncation
   if ( (FID = fopen(filename, "w+")) == NULL )
      mexErrMsgTxt("Unable to open file.");

   // Find out the size of the data
   m = mxGetM(prhs[1]);
   n = mxGetN(prhs[1]);
   np = (int) mxGetScalar(mxGetField(prhs[2],0,"np"));
   
   // Check if double precision is being used
   if (mxGetScalar(mxGetField(prhs[2], 0, "dp")) == 121) 
      dp = true;

   // Calculate the main header values and pull anything special
   // from the header structure supplied
   hdr.nblocks = m;
   hdr.ntraces = 2 * m / np;
   hdr.np = np;
   if (dp)
      hdr.ebytes = 4;
   else
      hdr.ebytes = 2;
   hdr.tbytes = hdr.ebytes * hdr.np;
   hdr.bbytes = 2 * m * hdr.ebytes + sizeof(bhdr);
   hdr.vers_id    = (short) mxGetScalar(mxGetField(prhs[3], 0, "vers_id"));
   hdr.status     = (short) mxGetScalar(mxGetField(prhs[3], 0, "status"));
   hdr.nbheaders = 1;
   
   // Write the main header to file
   if (fwrite(&hdr, sizeof(hdr), 1, FID) != 1)
      mexErrMsgTxt("Failed to write main header.");

   // Check if the number of block headers equals the number of blocks
   // If yes, then use all the headers, otherwise replicate the first
   if (n != mxGetNumberOfElements(prhs[4]))
      use_first = true;
   
   // Get pointers to data
   pReal = mxGetPr(prhs[1]);
   pImag = mxGetPi(prhs[1]);
   nval  = mxGetNumberOfElements(prhs[1]);

   // Check the scaling to ensure it fits within the precision
   scale = 0.;
   for (i = 0; i < nval; i++) {
      if (scale < fabs(pReal[i]))
         scale = fabs(pReal[i]);
      if (scale < fabs(pImag[i]))
         scale = fabs(pImag[i]);
   }

   // Scale down by factors of two to fit within precision
   scale = modf(LN_TO_LOG2 * log(scale), &pfactor);
   if (dp)
      scale = pow(2., 31 - (int) pfactor);
   else
      scale = pow(2., 15 - (int) pfactor);
   
   // NEVER SCALE UP
   if (scale > 1.)
      scale = 1.;

   // Get the first block header as default values
   bhdr.scale     = (short) mxGetScalar(mxGetField(prhs[4], 0, "scale"));
   bhdr.status    = (short) mxGetScalar(mxGetField(prhs[4], 0, "status"));
   bhdr.mode      = (short) mxGetScalar(mxGetField(prhs[4], 0, "mode"));
   bhdr.ctcount   = (short) mxGetScalar(mxGetField(prhs[4], 0, "ctcount"));
   bhdr.lpval     = (float) mxGetScalar(mxGetField(prhs[4], 0, "rpval"));
   bhdr.rpval     = (float) mxGetScalar(mxGetField(prhs[4], 0, "lpval"));
   bhdr.lvl       = (float) mxGetScalar(mxGetField(prhs[4], 0, "lvl"));
   bhdr.tlt       = (float) mxGetScalar(mxGetField(prhs[4], 0, "tlt"));
   
   // Allocate space for temporary storage   
   k = malloc(hdr.ebytes*2*m);
   k_int = (int *) k;
   k_short = (short *) k;

   for (i = 0; i < n; i++) {
      
      // Read in the next block header if we are not just using
      // the first block header
      if (!use_first) {
         bhdr.scale     = (short) mxGetScalar(mxGetField(prhs[4], i, "scale"));
         bhdr.status    = (short) mxGetScalar(mxGetField(prhs[4], i, "status"));
         bhdr.mode      = (short) mxGetScalar(mxGetField(prhs[4], i, "mode"));
         bhdr.ctcount   = (short) mxGetScalar(mxGetField(prhs[4], i, "ctcount"));
         bhdr.lpval     = (float) mxGetScalar(mxGetField(prhs[4], i, "rpval"));
         bhdr.rpval     = (float) mxGetScalar(mxGetField(prhs[4], i, "lpval"));
         bhdr.lvl       = (float) mxGetScalar(mxGetField(prhs[4], i, "lvl"));
         bhdr.tlt       = (float) mxGetScalar(mxGetField(prhs[4], i, "tlt"));
      }
        
      // Always update index, which runs from 1 to nblocks
      bhdr.index  = (short) i + 1;

      // Write the header to disk
      if (fwrite(&bhdr, sizeof(bhdr), 1, FID) != 1)
         mexErrMsgTxt("Failed to write block header to disk.");
      
      // Copy and reformat the data
      for (j = 0; j < m; j++) {
         if (dp) {
            k_int[2*j]     = (int) (pReal[i*m + j] * scale);
            k_int[2*j + 1] = (int) (pImag[i*m + j] * scale);
         }
         else {
            k_short[2*j]     = (short) (pReal[i*m + j] * scale);
            k_short[2*j + 1] = (short) (pImag[i*m + j] * scale);
         }
      }

      // Write the data block to disk
      if (fwrite(k, hdr.ebytes, 2*m, FID) != 2*m)
         mexErrMsgTxt("Failed to write block data to disk.");
   }

   // Free up the memory and file pointer
   free(k);
   fclose(FID);

   // Get the file name
   mxGetString(prhs[0], filename2, FILENAME_MAX);
   strcat(filename2, "/fid");
   
   // Copy the original data to a backup
   if (!cleanup) {
      mxGetString(prhs[0], filename3, FILENAME_MAX);
      strcat(filename3, "/fid.orig");
      rename(filename2, filename3);
   }
   // Copy the temporary swap to the final location
   rename(filename, filename2);
}
   
      
