#Charge une instance
#@param file le nom du fichier contenant l'instance à charger
#@return la capacité des bins
#@return les tailles des objets
#@return le nombre d'objet d'une même taille, pour chaque taille
#@return le nombre de taille différente
function loadInstance(file)
    dir="Instance/"
    println("loading instance")
    f::IOStream = open("$dir$file","r")
    s::String = readline(f)
    tab = parse.(Int64,split(s," ",keepempty = false))
    println(tab)
    valOptimale=tab[3]
    C = tab[1]
    w=[]
    d=[]
    for i in 1:tab[2]-1
        s = readline(f)
        push!(w,parse.(Int64,s))
    end
    sort!(w)
    precedentW=w[1]
    compteurD=1
    for i in 2:length(w)
        if precedentW==w[i]
            compteurD+=1
        else
            push!(d,compteurD)
            compteurD=1
            precedentW=w[i]
        end
    end
    push!(d,compteurD)
    unique!(w)
    k=length(w)
    #println(C)
    #println(w)
    #println(d)
    #println(k)
    return (C, w, d, k, valOptimale)
end