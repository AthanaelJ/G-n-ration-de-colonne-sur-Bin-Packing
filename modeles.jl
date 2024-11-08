#Paramètre le model, retrourn le model, les variables et les contraintes
#@param m patterns
#@param d demande d'objet d'une même taille
#@param k nombre d'objet de taille différente
#@return le model créé
#@return les variables associé au model
#@return les contraintes associé au model
function binPackingModel(m, d, k)
    n = size(m, 1)
    binPacking = Model(HiGHS.Optimizer)
    set_silent(binPacking) #pas d'output
    tlim = 10.0 #on met une limite de temps car on se fiche que la résolution ne soit pas fini
    set_time_limit_sec(binPacking, tlim)
    @variable(binPacking, x[1:n] >= 0, Int)
    unset_integer.(x) #on relache le problem pour accelerer la résolution, on n'aura pas de probleme à avoir des variables non entière
    @constraint(binPacking, contraintes[j=1:k], sum(m[i,j]*x[i] for i=1:n) >= d[j])
    @objective(binPacking, Min, sum(x[i] for i=1:n))

    #print(binPacking)
    optimize!(binPacking)
    println("Status bin packing : ", termination_status(binPacking))
    
    return (binPacking, x, contraintes)
end

#Détermine le pattern à ajouter à l'aide du dual, retourn le pattern ou rien si pas de nouveau pattern
#@param C capacité des bins
#@param w la taille des objets
#@param dualPi dual des contraintes
#@param k nombre d'objet de taille différente
#@retun nouveau pattern ou rien
function pricingProblemModel(C, w, dualPi, k)
    pricing = Model(HiGHS.Optimizer) 
    set_silent(pricing) #pas d'output
    @variable(pricing, y[1:k] >= 0, Int)
    @constraint(pricing, contrainte, sum(w[j]*y[j] for j=1:k) <= C)
    @objective(pricing, Max, sum(dualPi[j]*y[j] for j=1:k))

    #print(pricing)
    optimize!(pricing)
    println("Status pricing : ", termination_status(pricing))


    valeurObjectif = objective_value(pricing)
    println("valeur objectif pricing : ", valeurObjectif)
    #println(value.(y))
    if valeurObjectif <= 1 + 1e-8
        return nothing
    else
        return round.(Int, value.(y))
    end
end