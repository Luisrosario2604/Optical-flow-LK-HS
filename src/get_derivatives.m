function [Ix, Iy, It] = getDerivatives(imagen1, imagen2, method)

if size(imagen2,1)==0
    imagen2=zeros(size(imagen1));
end

% Una forma alternativa de calcular las derivadas espaciotemporales es utilizar diferencias de mascaras.
if method == 0
    Ix = conv2(imagen1,[1 -1]);
    Iy = conv2(imagen1,[1; -1]);
    It = imagen2-imagen1;

% Metodo original para Horn-Schunck
elseif method == 1
    Ix = conv2(imagen1,0.25* [-1 1; -1 1],'same') + conv2(imagen2, 0.25*[-1 1; -1 1],'same');
    Iy = conv2(imagen1, 0.25*[-1 -1; 1 1], 'same') + conv2(imagen2, 0.25*[-1 -1; 1 1], 'same');
    It = conv2(imagen1, 0.25*ones(2),'same') + conv2(imagen2, -0.25*ones(2),'same');

% Derivadas propuestas por Barron
% Mas info : https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.160.2526&rep=rep1&type=pdf
elseif method == 2
    Ix= conv2(imagen1,(1/12)*[-1 8 0 -8 1],'same');
    Iy= conv2(imagen1,(1/12)*[-1 8 0 -8 1]','same');
    It = conv2(imagen1, 0.25*ones(2),'same') + conv2(imagen2, -0.25*ones(2),'same');
    Ix=-Ix;
    Iy=-Iy;

% Derivada partial (Para Lucas-Kanade por ejemplo)
else
    Ix = conv2(imagen1,[-1 1; -1 1], 'valid');
    Iy = conv2(imagen1, [-1 -1; 1 1], 'valid');
    It = conv2(imagen1, ones(2), 'valid') + conv2(imagen2, -ones(2), 'valid');
end