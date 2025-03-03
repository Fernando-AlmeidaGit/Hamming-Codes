import numpy as np

def hamming74_demo():
    # Bits de informação (4 bits)
    original_data = [1, 0, 1, 1]
    print(f'Dados originais de 4 bits: {original_data}')
    
    # Codificação Hamming (7,4)
    encoded = hamming74_encode(original_data)
    print(f'Código Hamming de 7 bits codificado: {encoded}')
    
    # Introduzindo erros aleatórios
    received, error_pos = introduce_error(encoded)
    print(f'Recebido (com erro): {received}')
    
    # Decodificação e correção de erros
    decoded_data, corrected_codeword, corrected_pos = hamming74_decode(received)
    
    print(f'Palavra-código corrigida: {corrected_codeword}')
    print(f'Dados decodificados de 4 bits: {decoded_data}')
    
    if corrected_pos != 0:
        print(f'Erro detectado na posição {corrected_pos} e corrigido.')
    else:
        print('Nenhum erro detectado.')

def hamming74_encode(data_bits):
    # Codifica os 4 bits de informação em uma palavra-código de 7 bits
    d1, d2, d3, d4 = data_bits
    
    # Cálculo dos bits de paridade
    p1 = (d1 + d2 + d4) % 2
    p2 = (d1 + d3 + d4) % 2
    p3 = (d2 + d3 + d4) % 2
    
    # Construção da palavra-código de 7 bits
    return [p1, p2, d1, p3, d2, d3, d4]

def introduce_error(codeword):
    # Introduz um erro aleatório na palavra-código de 7 bits
    error_pos = np.random.randint(0, 7)  # Escolhe um bit aleatório para inverter
    received = codeword.copy()
    received[error_pos] = (received[error_pos] + 1) % 2  # Inverte o bit
    return received, error_pos + 1  # Ajusta para posição iniciando de 1

def hamming74_decode(received):
    # Decodifica a palavra-código de 7 bits recebida e corrige erros
    p1, p2, d1, p3, d2, d3, d4 = received
    
    # Calcula os bits de síndrome
    s1 = (p1 + d1 + d2 + d4) % 2
    s2 = (p2 + d1 + d3 + d4) % 2
    s3 = (p3 + d2 + d3 + d4) % 2
    
    # Calcula a posição do erro
    error_pos = s1 + 2 * s2 + 4 * s3
    
    # Corrige o erro, se encontrado
    corrected_codeword = received.copy()
    if error_pos != 0:
        print(f'Erro detectado na posição {error_pos}. Corrigindo...')
        corrected_codeword[error_pos - 1] = (corrected_codeword[error_pos - 1] + 1) % 2  # Inverte o bit
    
    # Extrai os dados originais de 4 bits
    decoded_data = [corrected_codeword[2], corrected_codeword[4], corrected_codeword[5], corrected_codeword[6]]
    return decoded_data, corrected_codeword, error_pos

if __name__ == "__main__":
    hamming74_demo()
