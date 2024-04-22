import random


def to_binary(n, length):
    # Handle negative numbers with two's complement
    if n < 0:
        return format((1 << length) + n, '0{}b'.format(length))
    else:
        return format(n, '0{}b'.format(length))


random_opcode = ["0110111", "0010111", "1101111", "1100111", "1100011", "0000011", "0100011", "0010011", "0110011", "0001111", "1110011"]
random_funct3b = ["000", "001", "011", "100", "101", "110", "111"]  # Branch 
random_funct3l = ["000", "001", "010", "100", "101"]  # Load 
random_funct3s = ["000", "001", "010"]  # Store 
random_funct3i = ["000", "010", "011", "100", "110", "111"]  # Immediate arithmetic/logical 
random_funct3r = ["000", "001", "010", "011", "100", "101", "110", "111"]  # Register arithmetic/logical 


readyinputs = []
i=0
#generate up to 20 instruction program automatically
for _ in range(20):
    opcode = random.choice(random_opcode) 
    # Immediate values for different instruction formats limited to 64 for simplicity
    u_imm = to_binary(random.randint(0, 64), 20)
    i_imm = to_binary(random.randint(0, 64), 12)
    b_imm = to_binary(random.randint(0, 64), 12)
    s_imm = to_binary(random.randint(0, 64), 12)


    # Register identifiers as 5-bit binary values
    rd = to_binary(random.randint(0, 31), 5)
    rs1 = to_binary(random.randint(0, 31), 5)
    rs2 = to_binary(random.randint(0, 31), 5)
    shamt = to_binary(random.randint(0, 31), 5)  # Shift amount for shift instructions

    # Generate final instruction
    if opcode in ["0110111", "0010111", "1101111"]:  # LUI, AUIPC, JAL 
        final_output = u_imm + rd + opcode
    elif opcode == "1100111":  # JALR 
        final_output = i_imm + rs1 + "000" + rd + opcode
    elif opcode == "1100011":  # Branch 
        funct3 = random.choice(random_funct3b)
        final_output = b_imm[-7:] + rs2 + rs1 + funct3 + b_imm[:5] + opcode
    elif opcode == "0000011":  # Load 
        funct3 = random.choice(random_funct3l)
        final_output = i_imm + rs1 + funct3 + rd + opcode
    elif opcode == "0100011":  # Store 
        funct3 = random.choice(random_funct3s)
        final_output = s_imm[:7] + rs2 + rs1 + funct3 + s_imm[7:] + opcode
    elif opcode == "0010011":  # Immediate arithmetic/logical 
        funct3 = random.choice(random_funct3i)
        if funct3 in ["001", "101"]:  # Shift left/right
            funct7 = "0000000" if random.randint(0, 1) == 0 else "0100000"
            final_output = funct7 + shamt + rs1 + funct3 + rd + opcode
        else:
            final_output = i_imm + rs1 + funct3 + rd + opcode
    elif opcode == "0110011":  # Register arithmetic/logical 
        funct3 = random.choice(random_funct3r)
        funct7 = "0000000" if random.randint(0, 1) == 0 else "0100000"
        final_output = funct7 + rs2 + rs1 + funct3 + rd + opcode
    elif opcode in ["0001111", "1110011"]:  # FENCE and SYSTEM instructions
        final_output = ("00000000000000000000" if random.randint(0, 1) == 0 else "00000000000100000000") + opcode
    else:
        print(f"{opcode} Error")
        continue

    if len(final_output) == 32:
        readyinput = ("mem[" +str(i)+ "] = 32'b" + final_output+";")
        print(final_output)
        readyinputs.append(readyinput)
        i = i+1
    
directory_path = r"C:\\Users\\saso-\\Desktop\\uniWork\\ArchProject\\Milestone2ArchProject\\TestPrograms\\AutoTestGen"  # Use raw string to avoid escaping issues
file_name = "InstMemAuto.txt"
full_path = directory_path + "\\" + file_name



with open(full_path, 'w') as file:
    for instruction in readyinputs:
        file.write(instruction + "\n")

print("Instructions saved to "+ file_name)
