
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "matrix.h"

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
   int m, n, numpnts, i, j;
   int dc_correct = 1;
   double xoffset = 0.;
   double yoffset = 0.;
   double *pReal, *pImag;
   char filename[FILENAME_MAX];
   FILE *FID;
   short *k_short;
   long  *k_long;
   void  *k;
   struct datafilehead  hdr;
   struct datablockhead bhdr;
   double shift_correct = 0.;
   mxArray *tmp_matrix;

   if (nlhs > 3) 
      mexErrMsgTxt("Too many output arguments.");

   if (nrhs < 2)
      mexErrMsgTxt("Too few input arguments.");

   if (nrhs >= 3)
      dc_correct = (int) mxGetScalar(prhs[2]);
   
   // Figure out if DC correction is required
   if (dc_correct > 0) {
      if (mxIsStruct(prhs[1])) {
         if ( (tmp_matrix = mxGetField(prhs[1], 0, "nt")) == NULL )
            mexErrMsgTxt("Parameter structure does not contain nt.");
         else
            shift_correct = mxGetScalar(tmp_matrix);
      }

      if (fmod(shift_correct, 2.) > 0.5)
         dc_correct = 1;

      shift_correct = fmod(shift_correct, 4);
   }

   // Get the file name and append /fid
   mxGetString(prhs[0], filename, FILENAME_MAX);
   strcat(filename, "/fid");
   
   // Open the file for reading
   if ( (FID = fopen(filename, "r")) == NULL )
      mexErrMsgTxt("Unable to open file.");

   // Get the main header
   if (fread(&hdr, sizeof(hdr), 1, FID) != 1)
      mexErrMsgTxt("Unable to read main header.");
   
   // Compute the number of data points to read
   m = hdr.ntraces * hdr.tbytes / hdr.ebytes;
   n = hdr.nblocks;
   numpnts = m / 2;

   // Allocate the space to read in one block at a time
   if ( (k = malloc(m*hdr.ebytes)) == NULL )
      mexErrMsgTxt("Unable to allocate space for reading data.");
   
   k_long = (long *) k;
   k_short = (short *) k;

   // Create the return matrix and get pointers to 
   // the real and imaginary parts
   plhs[0] = mxCreateDoubleMatrix(numpnts, n, mxCOMPLEX);
   pReal = mxGetPr(plhs[0]);
   pImag = mxGetPi(plhs[0]);
   
   // Initialize the block header structure
   if (nlhs > 2)
      plhs[2] = mxCreateStructMatrix(1, n, 9, bhdrnames);
   
   for (i=0; i < n; i++) {
      // Read in one block
      if ( fread(&bhdr, sizeof(bhdr), 1, FID) != 1 )
         mexErrMsgTxt("Unable to read block header.");
      if ( fread(k, hdr.ebytes, m, FID) != m )
         mexErrMsgTxt("Unable to read data block");

      // Compute the required DC correction
      if (dc_correct) {
         if (shift_correct > 2.5) {
            xoffset = (double) -bhdr.tlt;
            yoffset = (double) bhdr.lvl;
         }
         else {
            xoffset = (double) bhdr.lvl;
            yoffset = (double) bhdr.tlt;
         }

         // Zero the lvl and tlt since we are correcting
         // the data now 
         bhdr.tlt = 0.;
         bhdr.lvl = 0.;
      }

      // Copy the data into output matrix
      for (j=0; j < numpnts; j++) {
         if (hdr.ebytes == 2) {
            pReal[i*numpnts + j] = (double) k_short[2*j] - xoffset;
            pImag[i*numpnts + j] = (double) k_short[2*j+1] - yoffset;
         }
         else {
            pReal[i*numpnts + j] = (double) k_long[2*j] - xoffset;
            pImag[i*numpnts + j] = (double) k_long[2*j+1] - yoffset;
         }
      }

      // Populate the block header structure
      if (nlhs > 2) {
         mxSetFieldByNumber(plhs[2], i, 0, mxCreateScalarDouble(bhdr.scale));
         mxSetFieldByNumber(plhs[2], i, 1, mxCreateScalarDouble(bhdr.status));
         mxSetFieldByNumber(plhs[2], i, 2, mxCreateScalarDouble(bhdr.index));
         mxSetFieldByNumber(plhs[2], i, 3, mxCreateScalarDouble(bhdr.mode));
         mxSetFieldByNumber(plhs[2], i, 4, mxCreateScalarDouble(bhdr.ctcount));
         mxSetFieldByNumber(plhs[2], i, 5, mxCreateScalarDouble(bhdr.lpval));
         mxSetFieldByNumber(plhs[2], i, 6, mxCreateScalarDouble(bhdr.rpval));
         mxSetFieldByNumber(plhs[2], i, 7, mxCreateScalarDouble(bhdr.lvl));
         mxSetFieldByNumber(plhs[2], i, 8, mxCreateScalarDouble(bhdr.tlt));
      }
   }

   // Close the file
   fclose(FID);
   free(k);

   // Create the main header structure
   if (nlhs > 1) {
      plhs[1] = mxCreateStructMatrix(1,1,9, hdrnames);
      mxSetFieldByNumber(plhs[1], 0, 0, mxCreateScalarDouble(hdr.nblocks));
      mxSetFieldByNumber(plhs[1], 0, 1, mxCreateScalarDouble(hdr.ntraces));
      mxSetFieldByNumber(plhs[1], 0, 2, mxCreateScalarDouble(hdr.np));
      mxSetFieldByNumber(plhs[1], 0, 3, mxCreateScalarDouble(hdr.ebytes));
      mxSetFieldByNumber(plhs[1], 0, 4, mxCreateScalarDouble(hdr.tbytes));
      mxSetFieldByNumber(plhs[1], 0, 5, mxCreateScalarDouble(hdr.bbytes));
      mxSetFieldByNumber(plhs[1], 0, 6, mxCreateScalarDouble(hdr.vers_id));
      mxSetFieldByNumber(plhs[1], 0, 7, mxCreateScalarDouble(hdr.status));
      mxSetFieldByNumber(plhs[1], 0, 8, mxCreateScalarDouble(hdr.nbheaders));
   }
}
