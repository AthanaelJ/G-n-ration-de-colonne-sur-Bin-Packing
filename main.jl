using JuMP, HiGHS, LinearAlgebra
include("loadInstance.jl")
include("modeles.jl")
include("generationColonne.jl")
include("fonctionsPrint.jl")

function main(instance)
    (C, w, d, k, valOptimale)=loadInstance(instance)#on charge les données

    println("\n"^4)
 
    n = length(w) #nombre de pattern initiaux équivalant au nombre d'objet différent
    m = Matrix(1I, n, n) #patterns initiaux
 
    (binPacking, x, contraintes)=binPackingModel(m, d, k)

    printResultats(binPacking, x, k, m)

    (fini, m) = ajoutPattern(contraintes, C, w, m, k)#on essaye d'ajouter un pattern avec le dual
    while fini==false #tant que l'on peut rajouter un pattern
       
        println("\n"^4)

        (binPacking, x, contraintes)=binPackingModel(m, d, k)
        printResultats(binPacking, x, k, m)
        (fini, m) = ajoutPattern(contraintes, C, w, m, k)#on essaye d'ajouter un pattern avec le dual
    end

    println("\n"^4)

    set_integer.(x) #on remet les variables en entier
    optimize!(binPacking)
    println("Status : ", termination_status(binPacking))

    printResultats(binPacking, x, k, m)

    println("\nSachant que la valeur optimale (d'après le fichier de l'instance) est : ", valOptimale)
end