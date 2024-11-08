function printResultats(binPacking, x, k, m)
    n = size(m,1)
    println("Résultat")
    if has_values(binPacking)
        println("Nombre de bin utilisé : ", round(Int,objective_value(binPacking)))
        if k<20 #au delà ça devient illisible
            for i=1:n
                if value(x[i])!=0.0
                    #println("Pattern ", i, " : ", m[i,:], " utilisé ", value(x[i]), " fois.")
                end
            end
        end
    else
        println("Aucune solution trouvé dans la limite de temps.")
    end
end