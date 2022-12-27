function [imagen1_path, imagen2_path, imagen1, imagen2] = choose_image(option)

if option == 0
    imagen1_path = "../data/radio1.png";
    imagen2_path = "../data/radio2.png";

elseif option == 1
    imagen1_path = "../data/tennis1.jpg";
    imagen2_path = "../data/tennis2.jpg";
elseif option == 2
    imagen1_path = "../data/Perfect1.png";
    imagen2_path = "../data/Perfect3.png";
elseif option == 3
    imagen1_path = "../data/shoe1.jpg";
    imagen2_path = "../data/shoe3.jpg";
elseif option == 4
    imagen1_path = "../data/monkey1.jpg";
    imagen2_path = "../data/monkey2.jpg";
elseif option == 5
    imagen1_path = "../data/marple1.jpg";
    imagen2_path = "../data/marple2.jpg";
else
    imagen1_path = "../data/Car1.png";
    imagen2_path = "../data/Car2.png";
end

imagen1 = imread(imagen1_path);
imagen2 = imread(imagen2_path);

% datasets encontrado en :
% https://lmb.informatik.uni-freiburg.de/resources/datasets/sequences.en.html
