import random

# Function to convert integer to binary string with specific length
def to_binary(n, length):
    return f'{n:0{length}b}'

# List of random codes and function selectors
random_opcode = ["0110111", "0010111", "1101111", "1100111", "1100011", "0000011", "0100011", "0010011", "0110011", "0001111", "1110011"]
random_funct3b = ["000", "001", "011", "100", "101", "110", "111"]
random_funct3l = ["000", "001", "010", "100", "101"]
random_funct3s = ["000", "001", "010"]
random_funct3i = ["000", "010", "011", "100", "110", "111"]
random_funct3r = ["000", "001", "010", "011", "100", "101", "110", "111"]

# Main loop to generate test cases
for _ in range(100):
    opcode = random.choice(random_opcode)
    u_imm = to_binary(random.randint(0, 1048575), 20)
    i_imm = to_binary(random.randint(0, 4095), 12)
    b_imm = to_binary(random.randint(0, 4095), 12)
    s_imm = to_binary(random.randint(0, 4095), 12)
    rd = to_binary(random.randint(0, 31), 5)
    rs1 = to_binary(random.randint(0, 31), 5)
    rs2 = to_binary(random.randint(0, 31), 5)
    shamt = to_binary(random.randint(0, 31), 5)

    # Generate outputs based on opcode
    if opcode == "0110111" or opcode == "0010111" or opcode == "1101111":
        final_output = u_imm + rd + opcode
    elif opcode == "1100111":
        final_output = i_imm + rs1 + "000" + rd + opcode
    elif opcode == "1100011":
        funct3 = random.choice(random_funct3b)
        final_output = b_imm[-7:] + rs2 + rs1 + funct3 + b_imm[:5] + opcode
    elif opcode == "0000011":
        funct3 = random.choice(random_funct3l)
        final_output = i_imm + rs1 + funct3 + rd + opcode
    elif opcode == "0100011":
        funct3 = random.choice(random_funct3s)
        final_output = s_imm[:7] + rs2 + rs1 + funct3 + s_imm[7:] + opcode
    elif opcode == "0010011":
        funct3 = random.choice(random_funct3i)
        if funct3 == "001" or funct3 == "101":
            funct7 = "0000000" if random.randint(0, 1) == 0 else "0100000"
            final_output = funct7 + shamt + rs1 + funct3 + rd + opcode
        else:
            final_output = i_imm + rs1 + funct3 + rd + opcode
    elif opcode == "0110011":
        funct3 = random.choice(random_funct3r)
        funct7 = "0000000" if random.randint(0, 1) == 0 else "0100000"
        final_output = funct7 + rs2 + rs1 + funct3 + rd + opcode
    elif opcode == "0001111" or opcode == "1110011":
        final_output = ("00000000000000000000" if random.randint(0, 1) == 0 else "00000000000100000000") + opcode
    else:
        print(f"{opcode} Error")
        continue

    # Check and print the output if length is correct
    if len(final_output) == 32:
        print(final_output)
