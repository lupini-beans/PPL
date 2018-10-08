using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

class MALLexer
{
    string line;

    int lineNum = 0;

    int[] numOfErrors = { 0, 0, 0, 0, 0, 0, 0 };

    string[] errorType =
    {
        "Ill-Formed Labels: ",
        "Invalid Opcode: ",
        "Too Many Operands: ",
        "Too Few Operands: ",
        "Ill-Formed Operands: ",
        "Wrong Operand Type: ",
        "Label Warnings: "
    };

    List<string> toWrite = new List<string>();

    List<string> labelsDeclared = new List<string>();

    List<string> labelsEncountered = new List<string>();

    string[] validRegisters = { "R0", "R1", "R2", "R3", "R4", "R5", "R6", "R7" };

    Dictionary<string, char[]> instructions = new Dictionary<string, char[]>()
    {
        {"MOVE", new char[] {'s','d'}},
        {"MOVEI", new char[] {'v','d'}},
        {"ADD", new char[] {'s', 's', 'd'}},
        {"INC", new char[] {'s'}},
        {"SUB", new char[] {'s','s', 'd'}},
        {"DEC", new char[] {'s'}},
        {"MUL", new char[] {'s','s', 'd'}},
        {"DIV", new char[] {'s','s', 'd'}},
        {"BEQ", new char[] {'s', 's', 'l'}},
        {"BLT", new char[] {'s', 's', 'l'}},
        {"BGT", new char[] {'s','s', 'l'}},
        {"BR", new char[] {'l'}},
        {"END", new char[] {}}
    };

    Dictionary<string, List<int>> labelErrors = new Dictionary<string, List<int>>();

    public void OpenFile(string fileName, string outFileName)
    {
        try
        {
            StreamReader file = new StreamReader(fileName);

            while (file.Peek() >= 0)
            {
                line = file.ReadLine();

                lineNum++;

                string pureLine = CleanUp(line);

                if (!string.IsNullOrEmpty(pureLine))
                {
                    toWrite.Add(lineNum + ". " + pureLine);

                    var parsedLine = Parse(pureLine);

                    string label = parsedLine.Item1;

                    string instruction = "";

                    string validInstruction = "";

                    List<string> splitOperands = new List<string>();

                    if (parsedLine.Item2.Any())
                    {
                        instruction = parsedLine.Item2[0];

                        string operands = string.Join("", parsedLine.Item2.GetRange
                                                      (1, parsedLine.Item2.Count - 1));

                        List<string> operand = new List<string>(operands.Split(','));
                        if (operands == "")
                        {
                            operand.Clear();
                        }
                        for (int ops = 0; ops < operand.Count; ops++)
                        {
                            splitOperands.Add(operand[ops]);
                        }
                    }
                    if (!(string.IsNullOrEmpty(label)))
                    {
                        label = LabelCheck(label);
                        LabelUse(label);
                    }

                    if (!(string.IsNullOrEmpty(instruction)))
                    {
                        validInstruction = InstructionCheck(instruction, splitOperands);
                    }

                    if (instructions.ContainsKey(validInstruction))
                    {
                        validOperators(validInstruction, splitOperands);
                    }
                }
            }

            labelErrorRemove();

            writeOutFile(fileName, outFileName);

            file.Close();
        }
        catch (Exception E)
        {
            Console.WriteLine("Could not find file" + E);
        }
    }

    /// <summary>
    /// Strips comments off a line 
    /// </summary>
    /// <param name="line">The line to be checked for comments.</param>
    /// <returns>The line without comments</returns>
    public string CleanUp(string line)
    {
        if (line.StartsWith(';'))
        {
            line = "";
        }
        else if (line.Contains(';'))
        {
            string[] notComment = line.Split(';');
            line = notComment[0];
        }
        return line;
    }

    /// <summary>
    /// Parse splits the given line on spaces
    /// and colons 
    /// </summary>
    /// <param name="line">The line to be parsed</param>
    /// <returns>
    /// A tuple with a string that represents the label
    /// and a list of words that represent the instruction and variables
    /// </returns>
    public Tuple<string, List<string>> Parse(String line)
    {
        string label = "";
        List<string> word = new List<String>();

        line = line.Trim();
        word = line.Split(' ').ToList();
        if (word[0].Contains(':'))
        {
            label = word[0];
            word.RemoveAt(0);
        }

        return new Tuple<string, List<string>>(label, word);
    }

    /// <summary>
    /// Checks that the instruction is a valid instruction
    /// </summary>
    /// <param name="instruction">The expected instruction<parem>
    /// <parem name="splitOperands">The expected operands<parem>
    /// <returns> 
    /// The instruction or an empty string if the instruction is invalid
    /// </returns>
    public string InstructionCheck(string instruction, List<string> splitOperands)
    {
        int numOfOperands = 0;
        int operandLength = splitOperands.Count;
        string validInstruction = "";

        if (instructions.ContainsKey(instruction))
        {
            numOfOperands = instructions[instruction].Length;
            if (ValidOpLength(instruction, operandLength, numOfOperands))
            {
                validInstruction = instruction;
            }
        }
        else
        {
            toWrite.Add("\tERROR: Invalid Op Code");
            numOfErrors[1]++;
        }
        return validInstruction;
    }

    /// <summary> 
    /// Checks that the number of operands is valid for the given instruction
    /// </summary>
    /// <param name="instruction">The valid instruction</param>
    /// <param name="operandLength">The amount of operands found</param>
    /// <param name="numOfOperands">The amound of operands expected</param>
    /// <returns>Wether or not the found and expected lengths are the same</returns>
    public bool ValidOpLength(string instruction, int operandLength, int numOfOperands)
    {
        if (operandLength > numOfOperands)
        {
            toWrite.Add($"\tERROR: Too Many Operands - Expects {numOfOperands}");
            numOfErrors[2]++;
            return false;
        }

        if (operandLength < numOfOperands)
        {
            toWrite.Add($"\tERROR: Too Few Operands - Expects {numOfOperands}");
            numOfErrors[3]++;
            return false;
        }

        return true;
    }

    /// <summary>
    /// Checks that the operand types match the
    /// expected types of a valid instruction
    /// </summary>
    /// <param name="validInstruction">The validated instruction</param>
    /// <param name="operands">The operands found</param>
    public void validOperators(string validInstruction, List<string> operands)
    {
        char[] operandsExpected = instructions[validInstruction];
        for (int opNum = 0; opNum < operandsExpected.Length; opNum++)
        {
            if (operandsExpected[opNum] == 's' || operandsExpected[opNum] == 'd')
            {
                if (operands[opNum].All("01234567".Contains))
                {
                    toWrite.Add($"\tERROR: Wrong Operand Type - '{operands[opNum]}' " +
                     "should be a register or named memory location, not an immediate value.");
                    numOfErrors[5]++;
                }
                else if (!(operands[opNum].Length <= 5 && operands[opNum].All(Char.IsLetter)
                        || validRegisters.Contains(operands[opNum])))
                {
                    toWrite.Add($"\tERROR: Ill Formed Operand - '{operands[opNum]}' " +
                    "must be all characters and less than 5 in length, or R0-R7.");
                    numOfErrors[4]++;
                }
            }
            else if (operandsExpected[opNum] == 'v')
            {
                if (validRegisters.Contains(operands[opNum]))
                {
                    toWrite.Add($"\tERROR: Wrong Operand Type - '{operands[opNum]}' " +
                    "should be an octal, not a register.");
                    numOfErrors[5]++;
                }
                else if (operands[opNum].Length <= 5 && operands[opNum].All(Char.IsLetter))
                {
                    toWrite.Add($"\tERROR: Wrong Operand Type - '{operands[opNum]}' " +
                    "should be an octal, not a named memory location.");
                    numOfErrors[5]++;
                }
                else if (!(operands[opNum].All("01234567".Contains)))
                {
                    toWrite.Add($"\tERROR: Ill Formed Operand - '{operands[opNum]}' " +
                                "must be in octal format.");
                    numOfErrors[4]++;
                }
            }
            else if (operandsExpected[opNum] == 'l')
            {

                if (operands[opNum].Length <= 5 && operands[opNum].All(Char.IsLetter))
                {
                    labelsEncountered.Add(operands[opNum]);
                    if (!labelsDeclared.Contains(operands[opNum]))
                    {
                        toWrite.Add($"\tERROR: Invalid Label - '{operands[opNum]}' not declared");
                        numOfErrors[6]++;
                        if (!labelErrors.ContainsKey(operands[opNum]))
                        {
                            List<int> troll = new List<int>();
                            labelErrors.Add(operands[opNum], troll);
                        }
                        labelErrors[operands[opNum]].Add(toWrite.Count - 1);
                    }
                }
                else
                {
                    toWrite.Add($"\tERROR: Invalid Label - '{operands[opNum]}' must be all " +
                                "characters and less than 5 in length");
                    numOfErrors[6]++;
                }
            }
        }
    }

    /// <summary>
    /// Checks that an found label follows constraints
    /// </summary>
    /// <param name="label">The found label</param>
    /// <returns> The label without a semicolon </returns>
    public string LabelCheck(string label)
    {
        string[] pureLabel = label.Split(':');

        if (pureLabel[0].Length <= 5 && pureLabel[0].All(Char.IsLetter))
        {
            label = pureLabel[0];
            labelsDeclared.Add(label);
        }
        else if (pureLabel[0].Length > 5 && !pureLabel[0].All(Char.IsLetter))
        {
            toWrite.Add("\tERROR: Ill Formed Label - Label length must be 5 or " +
            "less characters and all alphabetical characters.");
            numOfErrors[0]++;
        }
        else if (pureLabel[0].Length > 5)
        {
            toWrite.Add("\tERROR: Ill Formed Label - Label length must be 5 or less characters.");
            numOfErrors[0]++;
        }
        else if (!pureLabel[0].All(Char.IsLetter))
        {
            toWrite.Add("\tERROR: Ill Formed Label - Label must be all alphabetical characters.");
            numOfErrors[0]++;
        }

        return label;
    }

    /// <summary> 
    /// Checks to see that all declared labels have been used and writes an error
    /// if it hasn't been. If an error is written, it records the line number
    /// of the error with the label in a dictionary to reference later
    /// </summary>
    /// <param name="label">The validated label<param>
    public void LabelUse(string label)
    {
        if (!labelsEncountered.Contains(label))
        {
            toWrite.Add($"\tLabel Warning: '{label}' not used");
            numOfErrors[6]++;
            if (!labelErrors.ContainsKey(label))
            {
                List<int> troll = new List<int>();
                labelErrors.Add(label, troll);
            }
            labelErrors[label].Add(toWrite.Count - 1);
        }
    }

    /// <summary>
    /// Checks that no label errors were thrown for labels that
    /// have been declared AND encountered
    /// If bad errors were thrown it removes them
    /// </summary>
    public void labelErrorRemove()
    {
        HashSet<int> toRemove = new HashSet<int>();
        var labelsUnion = labelsEncountered.ToHashSet().Intersect(labelsDeclared);
        foreach (string label in labelsUnion)
        {
            if (labelErrors.ContainsKey(label))
            {
                toRemove = toRemove.Union(labelErrors[label]).ToHashSet();
            }
        }
        foreach (int errorLine in toRemove.ToList().OrderByDescending(o => o))
        {
            toWrite.RemoveAt(errorLine);
            numOfErrors[6]--;
        }
    }

    /// <summary>
    /// Creates and writes collected data to an outfile
    /// </summary>
    /// <param name = "inputName"> The name of the input file.</param name>
    /// <param name = "outFileName"> The name of the output file.</param name>
    public void writeOutFile(string inputName, string outFileName)
    {
        FileStream outFile = File.Open(outFileName, FileMode.Create, FileAccess.Write);
        var timeStamp = new DateTime();
        var header = new List<string>
        {
            "MAL Lexer",
            inputName,
            outFileName,
            timeStamp.Date.ToString("d"),
            "Emily Lupini",
            "CS3210",
            new string('-', 80)
        };
        using (var sw = new StreamWriter(outFile))
        {
            foreach (string line in header)
            {
                sw.WriteLine(line);
            }

            for (int i = 0; i < toWrite.Count; i++)
            {
                sw.WriteLine(toWrite[i]);
            }
            sw.WriteLine(new string('-', 80));
            for (int i = 0; i < numOfErrors.Length; i++)
            {
                if (!(numOfErrors[i] == 0))
                {
                    sw.WriteLine(errorType[i] + numOfErrors[i]);
                }
            }
            sw.WriteLine("Total Errors: {0}", (numOfErrors.Sum()));
        }
    }
}