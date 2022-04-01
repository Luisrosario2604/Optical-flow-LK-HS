function [imagen1_path, imagen2_path, imagen1, imagen2] = choose_image(option)

if option == 0
    imagen1_path = "./Dataset/radio1.png";
    imagen2_path = "./Dataset/radio2.png";

elseif option == 1
    imagen1_path = "./Dataset/tennis1.jpg";
    imagen2_path = "./Dataset/tennis2.jpg";
elseif option == 2
    imagen1_path = "./Dataset/Perfect1.png";
    imagen2_path = "./Dataset/Perfect3.png";
elseif option == 3
    imagen1_path = "./Dataset/shoe1.jpg";
    imagen2_path = "./Dataset/shoe3.jpg";
elseif option == 4
    imagen1_path = "./Dataset/monkey1.jpg";
    imagen2_path = "./Dataset/monkey2.jpg";
elseif option == 5
    imagen1_path = "./Dataset/marple1.jpg";
    imagen2_path = "./Dataset/marple2.jpg";
else
    imagen1_path = "./Dataset/Car1.png";
    imagen2_path = "./Dataset/Car2.png";
end

imagen1 = imread(imagen1_path);
imagen2 = imread(imagen2_path);

% datasets encontrado en :
% https://lmb.informatik.uni-freiburg.de/resources/datasets/sequences.en.html
