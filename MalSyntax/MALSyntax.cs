    /* MAL Syntax takes a file with the extension ".mal"
    * and checks it for proper syntax of the specified MAL language.
    * All errors are counted and reported back to the user along with 
    * their original file stripped of blank lines and comments.
    * Did extra credit for detecting multiple errors on a single line.
    */
using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace MALSyntax
{
    class MainClass
    {
        public static void Main(string[] args)
        {
            foreach (string arg in args)
            {
                string inFileName;
                string outFileName;
                inFileName = arg;
                string[] fileParts = inFileName.Split('.');
                if (fileParts.Last() == "mal")
                {
                    fileParts[fileParts.Length-1] = "log";
                    outFileName = string.Join(".", fileParts);
                    var read = new MALLexer();
                    read.OpenFile(inFileName, outFileName);
                }
                else
                {
                    Console.WriteLine("Invalid file name. Must end in .mal");
                }
            }
        }
    }
}