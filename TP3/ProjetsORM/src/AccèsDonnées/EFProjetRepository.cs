using ProjetsORM.Entites;
using ProjetsORM.Persistence;
using System;

namespace ProjetsORM.AccesDonnees
{
    class EFProjetRepository
    {
        #region Champs
        #endregion

        private ProjetsORMContexte contexte;

        #region Constructeur
        public EFProjetRepository (ProjetsORMContexte contexte)
        {
            this.contexte = contexte;
        }
        #endregion

        #region Méthodes
        public void AjouterProjet(Projet projet)
        {
            contexte.Projets.Add(projet);
            contexte.SaveChanges();
        }
        #endregion
    }
}
