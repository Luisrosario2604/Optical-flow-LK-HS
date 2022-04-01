%% Luis ROSARIO MUVA 2022
% Metodo de Horn&Schunk
% Calcula el optical flow entre 2 imagenes con el metodo de Horn&Schunk
% visto en clase

%% Hacer un clear si necesidad
clear all;
tic

%% PARAMETROS !

[imagen1_path, imagen2_path, imagen1, imagen2] = choose_image(6);

lambda=40; % un parámetro que refleja la influencia del término de suavidad. (probar 0,1 - 60)

ite=50; % número de iteraciones (10 - 100)

u_zero = zeros(size(imagen1(:,:,1))); % valores iniciales para el flujo. Si se dispone de ellos, el flujo convergerá
v_zero = zeros(size(imagen2(:,:,1))); % más rápido y, por tanto, necesitará menos iteraciones; por defecto es cero. 

imagen_resultado = imagen1; % Imagen sobre la cual vamos a ver el flujo optico

gaussian_power = 1; % Cuantos pasos para el filtro gaussiano

option_derivativa = 1; % Que derivativa escoger (ver getDerivatives.m) (1 o 2)

ver_imagenes_originales = 0; % Ver las 2 imagenes originales

color = 'b'; % Color de la flechas para el flujo optico

linewidth = 3; % Tailla de la flechas para el flujo optico

arrows_count = 15; % Quantidad de flechas enseñadas : mas pequeño = mas flechas, mas grande = enseñar las mas importantes (Entre 5-40)

%% Visualizar las imagenes cargadas

if ver_imagenes_originales == 1
    subplot(1,2,1), imshow(imagen1)
    subplot(1,2,2), imshow(imagen2)
end

%% Information sobre las imagenes
% Tienes que ser de la misma tailla

[imagen1_rows, imagen1_columns, imagen1_numberOfColorChannels] = size(imagen1);
[imagen2_rows, imagen2_columns, imagen2_numberOfColorChannels] = size(imagen2);

fprintf('Imagen 1 : %d X %d con %d canales de color\n', imagen1_columns, imagen1_rows, imagen1_numberOfColorChannels);
fprintf('Imagen 2 : %d X %d con %d canales de color\n', imagen2_columns, imagen2_rows, imagen2_numberOfColorChannels);

if imagen1_columns ~= imagen2_columns
    disp("[ERROR] Las imagenes no tienen el mismo tamaño (columna)")
end
if imagen1_rows ~= imagen2_rows
    disp("[ERROR] Las imagenes no tienen el mismo tamaño (filas)")
end
if imagen1_numberOfColorChannels ~= imagen2_numberOfColorChannels
    disp("[ERROR] Las imagenes no tienen el mismo tamaño (canales)")
end
 
%% Rescalando las imagenes y pasar a escala de grises
% Para procesar mas rapidamente
% El resize depende de la tailla de la imagen dada

% im2double(I) convierte la imagen I a precisión doble. I puede ser una imagen de intensidad en escala de grises, una imagen truecolor o una imagen binaria. im2double reescala la salida de tipos de datos enteros al rango [0, 1].

if imagen1_numberOfColorChannels==3
    imagen1_gris=rgb2gray(imagen1);
else
    imagen1_gris=imagen1;
end
if imagen2_numberOfColorChannels==3
    imagen2_gris=rgb2gray(imagen2);
else
    imagen2_gris=imagen2;
end

imagen1_double = im2double(imagen1_gris);
%imagen1_resize = imresize(imagen1_double, resize_value);

imagen2_double = im2double(imagen2_gris);
%imagen2_resize = imresize(imagen2_double, resize_value);

%% Bonus : Hacer un smoothing con convolution con un kernel gaussiano 
% Para que ? Para reducir la sensibilidad al ruido (suavizado global)

tailla_kernel = 2*(gaussian_power * 3);

x = -(tailla_kernel / 2):(1 + 1 / tailla_kernel):(tailla_kernel / 2);
filtro_gaussiano = (1/(sqrt(2*pi)* gaussian_power)) * exp (-(x.^2)/(2*gaussian_power^2));


imagen1_smooth=conv2(imagen1_double, filtro_gaussiano, 'same');
imagen1_smooth=conv2(imagen1_smooth, filtro_gaussiano', 'same');

imagen2_smooth=conv2(imagen2_double, filtro_gaussiano, 'same');
imagen2_smooth=conv2(imagen2_smooth, filtro_gaussiano', 'same');


%% Establecer el valor inicial de los vectores de flujo
u = u_zero;
v = u_zero;

%% Estimar las derivadas espacio-temporales
% Se calculan los promedios y derivadas espacio-temporales
[Ix, Iy, It] = get_derivatives(imagen1_smooth, imagen2_smooth, option_derivativa);

%% Iteración

% Núcleo promedio
ventana = [1/12 1/6 1/12; 1/6 0 1/6; 1/12 1/6 1/12];

% Iterationes
for i=1:ite
    % Calcular las medias locales de los vectores de flujo
    u_power = conv2(u, ventana, 'same');
    v_power = conv2(v, ventana, 'same');
    % Se repiten las ecuaciones iterativas hasta convergencia
    u = u_power - ( Ix .* ( ( Ix .* u_power ) + ( Iy .* v_power ) + It ) ) ./ ( lambda^2 + Ix.^2 + Iy.^2); 
    v = v_power - ( Iy .* ( ( Ix .* u_power ) + ( Iy .* v_power ) + It ) ) ./ ( lambda^2 + Ix.^2 + Iy.^2);
end

u(isnan(u))=0;
v(isnan(v))=0;

%% reducir el tamaño de U y V
u_reduced = u(1:arrows_count:end, 1:arrows_count:end);
v_reduced = v(1:arrows_count:end, 1:arrows_count:end);

%% obtener las coordenadas de U y V en las imagen original
[m, n] = size(imagen1_smooth);
[X,Y] = meshgrid(1:n, 1:m);
X_reduced = X(1:arrows_count:end, 1:arrows_count:end);
Y_reduced = Y(1:arrows_count:end, 1:arrows_count:end);

toc

%% Ver el resultado con quiver()
figure();
imshow(imagen2);
hold on;
% dibujar los vectores de velocidad
quiver(X_reduced, Y_reduced, u_reduced, v_reduced, 'color', color, 'linewidth', linewidth)