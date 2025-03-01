function hamming74_demo()
    % Bits de informação (4 bits)
    original_data = [1, 0, 1, 1];
    fprintf('Dados originais de 4 bits: [%s]\n', num2str(original_data));

    % Codificação Hamming (7,4)
    encoded = hamming74_encode(original_data);
    fprintf('Código Hamming de 7 bits codificado: [%s]\n', num2str(encoded));

    % Introduzindo erros aleatórios
    [received, error_pos] = introduce_error(encoded);
    fprintf('Recebido (com erro): [%s]\n', num2str(received));

    % Decodificação e correção de erros
    [decoded_data, corrected_codeword, corrected_pos] = hamming74_decode(received);

    fprintf('Palavra-código corrigida: [%s]\n', num2str(corrected_codeword));
    fprintf('Dados decodificados de 4 bits: [%s]\n', num2str(decoded_data));

    if corrected_pos ~= 0
        fprintf('Erro detectado na posição %d e corrigido.\n', corrected_pos);
    else
        fprintf('Nenhum erro detectado.\n');
    end
end

function codeword = hamming74_encode(data_bits)
    % Codifica os 4 bits de informação em uma palavra-código de 7 bits
    d1 = data_bits(1);
    d2 = data_bits(2);
    d3 = data_bits(3);
    d4 = data_bits(4);

    % Cálculo dos bits de paridade
    p1 = mod(d1 + d2 + d4, 2);
    p2 = mod(d1 + d3 + d4, 2);
    p3 = mod(d2 + d3 + d4, 2);

    % Construção correta da palavra-código de 7 bits: [p1, p2, d1, p3, d2, d3, d4]
    codeword = [p1, p2, d1, p3, d2, d3, d4];
end

function [received, error_pos] = introduce_error(codeword)
    % Introduz um erro aleatório na palavra-código de 7 bits
    error_pos = randi([1, 7]); % Escolhe um bit aleatório para inverter
    received = codeword;
    received(error_pos) = mod(received(error_pos) + 1, 2); % Inverte o bit
end

function [decoded_data, corrected_codeword, error_pos] = hamming74_decode(received)
    % Decodifica a palavra-código de 7 bits recebida e corrige erros
    p1 = received(1);
    p2 = received(2);
    d1 = received(3);
    p3 = received(4);
    d2 = received(5);
    d3 = received(6);
    d4 = received(7);

    % Calcula os bits de síndrome corretamente
    s1 = mod(p1 + d1 + d2 + d4, 2);
    s2 = mod(p2 + d1 + d3 + d4, 2);
    s3 = mod(p3 + d2 + d3 + d4, 2);

    % Calcula a posição do erro corretamente
    error_pos = s1 + 2 * s2 + 4 * s3;

    % Corrige o erro, se encontrado
    corrected_codeword = received;
    if error_pos ~= 0
        fprintf('Erro detectado na posição %d. Corrigindo...\n', error_pos);
        corrected_codeword(error_pos) = mod(corrected_codeword(error_pos) + 1, 2); % Inverte o bit
    end

    % Extrai corretamente os dados originais de 4 bits
    decoded_data = [corrected_codeword(3), corrected_codeword(5), corrected_codeword(6), corrected_codeword(7)];
end
