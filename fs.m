function formatted_stress = fs(stress)
len = length(stress);
highest = stress(1);
for i = 1:len;
    if (stress(i) >= highest);
        highest = stress(i);
    elseif (stress(i) < highest);
            stress(i)= highest;
    end
end
formatted_stress = stress