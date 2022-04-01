%% Luis ROSARIO MUVA 2022
% Metodo de Lucas-Kanade
% Calcula el optical flow entre 2 imagenes con el metodo de Lucas-Kanade
% visto en clase


%% Hacer un clear si necesidad
clear all;
tic

%% PARAMETROS !

[imagen1_path, imagen2_path, imagen1, imagen2] = choose_image(1);

resize_value = 0.5; % sirve para reducir el tamaño de la imagen y de la ventana (coeficiente multiplicador)

arrows_count = 20; % Quantidad de flechas enseñadas : mas pequeño = mas flechas, mas grande = enseñar las mas importantes (Entre 5-40)

ventana_original = 45; % tailla de la ventana original

color = 'b'; % Color de la flechas para el flujo optico

linewidth = 2; % Tailla de la flechas para el flujo optico

ver_imagenes_originales = 0; % Ver las 2 imagenes originales (0 false, 1 true)


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

%% Rescalando las imagenes
% Para procesar mas rapidamente
% El resize depende de la tailla de la imagen dada

% im2double(I) convierte la imagen I a precisión doble. I puede ser una imagen de intensidad en escala de grises, una imagen truecolor o una imagen binaria. im2double reescala la salida de tipos de datos enteros al rango [0, 1].

imagen1_double = im2double(rgb2gray(imagen1));
imagen1_resize = imresize(imagen1_double, resize_value);

imagen2_double = im2double(rgb2gray(imagen2));
imagen2_resize = imresize(imagen2_double, resize_value);

 
%% Definir el tamaño de la ventana para L-K
% round(X) redondea cada elemento de X al entero más próximo
tailla_ventana = round(ventana_original * resize_value);
fprintf("Talla de la ventana : %d\n", tailla_ventana)

%% Calcular las derivadas espacio-temporales Ix, Iy, It
[Ix, Iy, It] = get_derivatives(imagen1_resize, imagen2_resize, 3);

%% Calcular la matriz 2x1 U,V
u = zeros(size(imagen1_resize));
v = zeros(size(imagen2_resize));
 
%% Calcular I_x, I_y, I_t para cada punto
for i = tailla_ventana+1:size(Ix,1)-tailla_ventana
   for j = tailla_ventana+1:size(Ix,2)-tailla_ventana
      Ix_punto = Ix(i-tailla_ventana:i+tailla_ventana, j-tailla_ventana:j+tailla_ventana);
      Iy_punto = Iy(i-tailla_ventana:i+tailla_ventana, j-tailla_ventana:j+tailla_ventana);
      It_punto = It(i-tailla_ventana:i+tailla_ventana, j-tailla_ventana:j+tailla_ventana);
      
      Ix_punto = Ix_punto(:);
      Iy_punto = Iy_punto(:);

      % A es igual a : [Ix_punto Iy_punto]
      % b es igual a : -It_punto(:)
      % Utilizamos la pseudoinversa de Moore-Penrose
      Pseudo_M_P = pinv([Ix_punto Iy_punto])*-It_punto(:); % Vector de velocidad para el punto X y Y
      
      u(i,j)=Pseudo_M_P(1);
      v(i,j)=Pseudo_M_P(2);
   end
end

disp("Done !")

%% reducir el tamaño de U y V

u_reduced = u(1:arrows_count * resize_value :end, 1:arrows_count * resize_value :end);
v_reduced = v(1:arrows_count * resize_value :end, 1:arrows_count * resize_value :end);

%% obtener las coordenadas de U y V en las imagen original
[m, n] = size(imagen1_double);
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
