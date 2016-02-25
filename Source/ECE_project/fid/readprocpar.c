#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "matrix.h"

#define BUFFER_LENGTH 2048

static const char *parnames[151] =
{
   "path",
   "dp",
   "seqfil",
   "nf",
   "ni",
   "sw",
   "ns",
   "ne1",
   "ne2",
   "rfspoil",
   "rfphase",
   "nt",
   "np",
   "nv",
   "nv2",
   "nv3",
   "ne",
   "polarity",
   "evenecho",
   "tr",
   "te",
   "esp",
   "espincr",
   "nprof",
   "tproj",
   "phi",
   "psi",
   "theta",
   "vpsi",
   "vphi",
   "vtheta",
   "array",
   "arraydim",
   "seqcon",
   "lro",
   "lpe",
   "lpe2",
   "pro",
   "ppe",
   "ppe2",
   "pss",
   "thk",
   "thk2",
   "pos1",
   "pos2",
   "pos3",
   "vox1",
   "vox2",
   "vox3",
   "nD",
   "cntr",
   "gain",
   "shimset",
   "z1",
   "z2",
   "z3",
   "z4",
   "z5",
   "z6",
   "z7",
   "z8",
   "x1",
   "y1",
   "xz",
   "yz",
   "xy",
   "x3",
   "y3",
   "x4",
   "y4",
   "z1c",
   "z2c",
   "z3c",
   "z4c",
   "xz2",
   "yz2",
   "xz2",
   "yz2",
   "zxy",
   "z3x",
   "z3y",
   "zx3",
   "zy3",
   "z4x",
   "z4y",
   "z5x",
   "z5y",
   "x2y2",
   "z2xy",
   "z3xy",
   "z2x3",
   "z2y3",
   "z3x3",
   "z3y3",
   "z4xy",
   "zx2y2",
   "z2x2y2",
   "z3x2y2",
   "z4x2y2",
   "petable",
   "nrcvrs",
   "trise",
   "at",
   "gro",
   "gmax",
   "intlv",
   "rcvrs",
   "celem",
   "arrayelemts",
   "contrast",
   "tep",
   "date",
   "ti",
   "gss2",
   "gss",
   "tpwri",
   "tpwr1",
   "tpwr2",
   "orient",
   "tof",
   "resto",
   "grox",
   "groy",
   "fov",
   "res",
   "npix",
   "nseg",
   "nzseg",
   "waveform",
   "SR",
   "gradfrac",
   "sfrq",
   "B0",
   "dtmap",
   "nnav",
   "tnav",
   "fast",
   "bt",
   "nhomo",
   "fpmult",
   "d1",
   "ss",
   "ssc",
   "r1",
   "r2",
   "ps_coils",
   "coil_array",
   "nav",
   "fliplist",
   "varflip",
   "spiral_gmax"
};


mexFunction(int nlhs, mxArray *plhs[],
      int nrhs, const mxArray *prhs[])
{
   
   int i, nval, lenb, count, count2, incr;
   mxArray *tmp_matrix, *tmp_matrix2;
   double *pReal;
   char buffer[BUFFER_LENGTH];
   char readbuffer[BUFFER_LENGTH];
   char *buffer2;
   FILE *FID;
   char filename[FILENAME_MAX];
   char value[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
   
   if (nrhs < 1)
      mexErrMsgTxt("Too few input arguments.");

   if (nlhs > 1)
      mexErrMsgTxt("Too many output arguments.");
   
   plhs[0] = mxCreateStructMatrix(1,1,151,parnames);

   mxGetString(prhs[0], filename, FILENAME_MAX);

   mxSetField(plhs[0], 0, "path", mxCreateString(filename));
   mxSetField(plhs[0], 0, "array", mxCreateCellMatrix(1,1));

   strcat(filename, "/procpar");
   
   if ( (FID = fopen(filename, "r")) == NULL)
      mexErrMsgTxt("Unable to open file.");

   fgets(buffer, BUFFER_LENGTH, FID);
   
   while (buffer != NULL) {
      if (strchr(value, buffer[0]) != NULL) {
         buffer2 = strstr(buffer, " ");
         buffer2[0] = '\0';
         lenb = buffer2 - buffer;
         
         
         if (lenb == 2) {
            if (!strncmp(buffer, "z1", 2) || 
                  !strncmp(buffer, "z2", 2) ||
                  !strncmp(buffer, "z3", 2) ||
                  !strncmp(buffer, "z4", 2) ||
                  !strncmp(buffer, "z5", 2) ||
                  !strncmp(buffer, "z6", 2) ||
                  !strncmp(buffer, "z7", 2) ||
                  !strncmp(buffer, "z8", 2) ||
                  !strncmp(buffer, "x1", 2) ||
                  !strncmp(buffer, "y1", 2) ||
                  !strncmp(buffer, "xz", 2) ||
                  !strncmp(buffer, "yz", 2) ||
                  !strncmp(buffer, "xy", 2) ||
                  !strncmp(buffer, "x3", 2) ||
                  !strncmp(buffer, "y3", 2) || 
                  !strncmp(buffer, "x4", 2) || 
                  !strncmp(buffer, "y4", 2) || 
                  !strncmp(buffer, "nD", 2) || 
                  !strncmp(buffer, "ti", 2) || 
                  !strncmp(buffer, "te", 2) || 
                  !strncmp(buffer, "np", 2) || 
                  !strncmp(buffer, "nf", 2) || 
                  !strncmp(buffer, "ni", 2) || 
                  !strncmp(buffer, "ns", 2) || 
                  !strncmp(buffer, "nv", 2) || 
                  !strncmp(buffer, "ne", 2) || 
                  !strncmp(buffer, "nt", 2) || 
                  !strncmp(buffer, "tr", 2) || 
                  !strncmp(buffer, "sw", 2) || 
                  !strncmp(buffer, "at", 2) || 
                  !strncmp(buffer, "SR", 2) || 
                  !strncmp(buffer, "bt", 2) || 
                  !strncmp(buffer, "d1", 2) || 
                  !strncmp(buffer, "ss", 2) ||
                  !strncmp(buffer, "r1", 2) ||
                  !strncmp(buffer, "r2", 2) || 
                  !strncmp(buffer, "B0", 2)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "dp", 2)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 3) {
            if (!strncmp(buffer, "z1c", 3) || 
                  !strncmp(buffer, "z2c", 3) || 
                  !strncmp(buffer, "z3c", 3) || 
                  !strncmp(buffer, "z4c", 3) || 
                  !strncmp(buffer, "xz2", 3) || 
                  !strncmp(buffer, "yz2", 3) || 
                  !strncmp(buffer, "zxy", 3) || 
                  !strncmp(buffer, "z3x", 3) || 
                  !strncmp(buffer, "z3y", 3) || 
                  !strncmp(buffer, "zx3", 3) || 
                  !strncmp(buffer, "zy3", 3) || 
                  !strncmp(buffer, "z4x", 3) || 
                  !strncmp(buffer, "z4y", 3) || 
                  !strncmp(buffer, "z5x", 3) || 
                  !strncmp(buffer, "z5y", 3) || 
                  !strncmp(buffer, "tep", 3) || 
                  !strncmp(buffer, "nv2", 3) || 
                  !strncmp(buffer, "nv3", 3) || 
                  !strncmp(buffer, "lpe", 3) || 
                  !strncmp(buffer, "ne2", 3) || 
                  !strncmp(buffer, "lro", 3) || 
                  !strncmp(buffer, "esp", 3) || 
                  !strncmp(buffer, "pro", 3) || 
                  !strncmp(buffer, "ppe", 3) || 
                  !strncmp(buffer, "pss", 3) || 
                  !strncmp(buffer, "phi", 3) || 
                  !strncmp(buffer, "psi", 3) || 
                  !strncmp(buffer, "thk", 3) || 
                  !strncmp(buffer, "gro", 3) || 
                  !strncmp(buffer, "gss", 3) || 
                  !strncmp(buffer, "tof", 3) || 
                  !strncmp(buffer, "fov", 3) || 
                  !strncmp(buffer, "ssc", 3) || 
                  !strncmp(buffer, "res", 3)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "nav", 3)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 4) {
            if (!strncmp(buffer, "x2y2", 4) || 
                  !strncmp(buffer, "z2xy", 4) || 
                  !strncmp(buffer, "z3xy", 4) || 
                  !strncmp(buffer, "z2x3", 4) || 
                  !strncmp(buffer, "z2y3", 4) || 
                  !strncmp(buffer, "z3x3", 4) || 
                  !strncmp(buffer, "z3y3", 4) || 
                  !strncmp(buffer, "z4xy", 4) || 
                  !strncmp(buffer, "lpe2", 4) || 
                  !strncmp(buffer, "sfrq", 4) || 
                  !strncmp(buffer, "nnav", 4) || 
                  !strncmp(buffer, "tnav", 4) || 
                  !strncmp(buffer, "ppe2", 4) || 
                  !strncmp(buffer, "thk2", 4) || 
                  !strncmp(buffer, "pos1", 4) || 
                  !strncmp(buffer, "pos2", 4) || 
                  !strncmp(buffer, "pos3", 4) || 
                  !strncmp(buffer, "vox1", 4) || 
                  !strncmp(buffer, "vox2", 4) || 
                  !strncmp(buffer, "vox3", 4) || 
                  !strncmp(buffer, "vpsi", 4) || 
                  !strncmp(buffer, "vphi", 4) || 
                  !strncmp(buffer, "gain", 4) || 
                  !strncmp(buffer, "cntr", 4) || 
                  !strncmp(buffer, "gmax", 4) || 
                  !strncmp(buffer, "gss2", 4) || 
                  !strncmp(buffer, "grox", 4) || 
                  !strncmp(buffer, "groy", 4) || 
                  !strncmp(buffer, "nseg", 4) || 
                  !strncmp(buffer, "npix", 4)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "date", 4) || 
                  !strncmp(buffer, "fast", 4)
                  ) {
               fscanf(FID, "%d \"%[^\"]\"", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 5) {
            if (!strncmp(buffer, "zx2y2", 5) || 
                  !strncmp(buffer, "celem", 5) || 
                  !strncmp(buffer, "dtmap", 5) || 
                  !strncmp(buffer, "theta", 5) || 
                  !strncmp(buffer, "resto", 5) || 
                  !strncmp(buffer, "nproj", 5) || 
                  !strncmp(buffer, "tproj", 5) || 
                  !strncmp(buffer, "trise", 5) || 
                  !strncmp(buffer, "tpwr1", 5) || 
                  !strncmp(buffer, "tpwr2", 5) || 
                  !strncmp(buffer, "tpwri", 5) || 
                  !strncmp(buffer, "nhomo", 5) || 
                  !strncmp(buffer, "nzseg", 5)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "intlv", 5)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "rcvrs", 5)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               nval = strlen(readbuffer);
               count = 0;
               for (i=0; i<nval; i++) {
                  if (readbuffer[i] == 'y')
                     count++;
               }
               mxSetField(plhs[0], 0, "nrcvrs", mxCreateScalarDouble((double) count));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "array", 5)
                  ) {
               readbuffer[0] = '\0';
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, readbuffer);
               nval = strlen(readbuffer);
               if (nval > 0) {
                  tmp_matrix = mxGetField(plhs[0], 0, "array");
                  
                  buffer2 = strtok(readbuffer, ",");
                  count = 0;
                  incr = 0;
                  while (buffer2 != NULL) {
                     mxSetN(tmp_matrix, count + 1);
                     
                     nval = strlen(buffer2) - 1;
                     if (buffer2[0] == '(') {
                        if (++incr > 1)
                           mexErrMsgTxt("Invalid coupling in array parameter.");
                        else {
                           tmp_matrix2 = mxCreateCellMatrix(1,1);
                           count2 = 0;
                           
                           if (buffer2[nval] == ')') {
                              incr = 0;
                              mxSetCell(tmp_matrix, count++, tmp_matrix2);
                              buffer2[nval] = '\0';
                           }
                           
                           mxSetCell(tmp_matrix2, count2++, mxCreateString(buffer2+1));
                        }
                     }
                     else if (buffer2[nval] == ')') {
                        if (--incr < 0)
                           mexErrMsgTxt("Invalid coupling in array parameter.");
                        else {
                           buffer2[nval] = '\0';
                           mxSetN(tmp_matrix2, count2+1);
                           mxSetCell(tmp_matrix2, count2++, mxCreateString(buffer2));
                           mxSetCell(tmp_matrix, count++, tmp_matrix2);
                        }
                     }
                     else {
                        if (incr == 1) {
                           mxSetN(tmp_matrix2, count2+1);
                           mxSetCell(tmp_matrix2, count2++, mxCreateString(buffer2));
                        }
                        else {
                           tmp_matrix2 = mxCreateCellMatrix(1,1);
                           mxSetCell(tmp_matrix2, 0, mxCreateString(buffer2));
                           mxSetCell(tmp_matrix, count++, tmp_matrix2);
                        }
                     }
                        
                     buffer2 = strtok(NULL, ",");
                  }
               }
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 6) {
            if (!strncmp(buffer, "z2x2y2", 6) || 
                  !strncmp(buffer, "z3x2y2", 6) || 
                  !strncmp(buffer, "z4x2y2", 6) || 
                  !strncmp(buffer, "fpmult", 6) || 
                  !strncmp(buffer, "vtheta", 6)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "seqfil", 6) || 
                  !strncmp(buffer, "seqcon", 6) || 
                  !strncmp(buffer, "orient", 6) 
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 7) {
            if (!strncmp(buffer, "espincr", 7) || 
                  !strncmp(buffer, "rfphase", 7) || 
                  !strncmp(buffer, "shimset", 7)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "rfspoil", 7) || 
                  !strncmp(buffer, "varflip", 7) || 
                  !strncmp(buffer, "petable", 7)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 8) {
            if (!strncmp(buffer, "evenecho", 8) || 
                  !strncmp(buffer, "polarity", 8) || 
                  !strncmp(buffer, "arraydim", 8) || 
                  !strncmp(buffer, "fliplist", 8) || 
                  !strncmp(buffer, "gradfrac", 8)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "waveform", 8) || 
                  !strncmp(buffer, "contrast", 8)
                  ) {
               fscanf(FID, "%d \"%[^\"]\" \n", &nval, &readbuffer);
               mxSetField(plhs[0], 0, buffer, mxCreateString(readbuffer));
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
            else if (!strncmp(buffer, "ps_coils", 8)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateCellMatrix(1, nval);
               for (i=0; i<nval; i++) {
                  fscanf(FID, " \"%[^\"]\" \n", readbuffer);
                  mxSetCell(tmp_matrix, i, mxCreateString(readbuffer));
               }
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 10) {
            if (!strncmp(buffer, "coil_array", 10)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateCellMatrix(1, nval);
               for (i=0; i<nval; i++) {
                  fscanf(FID, " \"%[^\"]\" \n", readbuffer);
                  mxSetCell(tmp_matrix, i, mxCreateString(readbuffer));
               }
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
         else if (lenb == 11) {
            if (!strncmp(buffer, "arrayelemts", 11) || 
                  !strncmp(buffer, "spiral_gmax", 11)
                  ) {
               fscanf(FID, "%d", &nval);
               tmp_matrix = mxCreateDoubleMatrix(1, nval, mxREAL);
               pReal = mxGetPr(tmp_matrix);
               mxSetField(plhs[0], 0, buffer, tmp_matrix);
               for (i=0; i<nval; i++)
                  fscanf(FID, "%lf", pReal+i);
               // Clear out the line
               fgets(buffer, BUFFER_LENGTH, FID);
               // Clear out the empty line
               fgets(buffer, BUFFER_LENGTH, FID);
            }
         }
      }
      
      if (feof(FID))
         break;
      
      fgets(buffer, BUFFER_LENGTH, FID);
      
   }

   fclose(FID);
   
}
               
