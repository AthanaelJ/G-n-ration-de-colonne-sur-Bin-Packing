#Ajoute un pattern à l'aide du dual
#@param contraintes contraintes associé au model
#@param C capacité des bins
#@param w la taille des objets
#@retun m listes des patterns 
#@param k nombre d'objet de taille différente
#@retun True si aucune nouveau pattern n'a été ajouté, False sinon
#@retun listes des patterns mise à jour
function ajoutPattern(contraintes, C, w, m, k) 
   dualPi = dual.(contraintes)
   #println(dualPi)
   nouveauPattern = pricingProblemModel(C, w, dualPi, k)
   fini=false
   if isnothing(nouveauPattern)
      @info "No new patterns, terminating the algorithm."
      fini=true
   else
      m = vcat(m, nouveauPattern')
      @info "New patterns."
      #print("  New pattern: ", nouveauPattern)
   end
   return (fini, m)
end