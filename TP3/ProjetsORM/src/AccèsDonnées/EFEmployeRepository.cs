using ProjetsORM.EntiteDTOs;
using ProjetsORM.Entites;
using ProjetsORM.Persistence;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ProjetsORM.AccesDonnees
{
    class EFEmployeRepository
    {
        #region Champs 
        #endregion

        private ProjetsORMContexte contexte;

        #region Constructeur
        public EFEmployeRepository(ProjetsORMContexte contexte)
        {
            this.contexte = contexte;
        }
        #endregion


        #region Méthodes
        public void AjouterEmploye(Employe employe)
        {
            contexte.Employes.Add(employe);
            contexte.SaveChanges();
        }

        private void ValiderEmploye(short id)
        {
            if (contexte.Employes.Find(id) == null) { throw new ArgumentException("L'employé n'existe pas"); }
        }

        public Employe ObtenirEmploye(short noEmploye)
        {
            ValiderEmploye(noEmploye);
            return contexte.Employes.Find(noEmploye);
        }

        public ICollection<Employe> RechercherTousLesSuperviseurs()
        {
            return contexte.Employes.Where(e => e.SousSupervision.Count() > 0).ToList();
        }

        public ICollection<Employe> RechercherEmployesSansSuperviseur()
        {
            return contexte.Employes.Where(e => e.Superviseur == null).ToList();
        }

        public InfosTravailEmploye ObtenirInformationEmploye(short noEmploye)
        {
            Employe e = ObtenirEmploye(noEmploye);
            return new InfosTravailEmploye
            {
                NoEmploye = e.NoEmploye,
                Nom = e.Nom,
                Prenom = e.Prenom,
                NbEmployesSupervises = e.SousSupervision.Count(),
                NbProjetEncoursGeres = e.ProjetGestionnaire.Where(p => p.DateDebut <= DateTime.Now && (p.DateFin == null || p.DateFin >= DateTime.Now)).Count(),
                NbProjetEncoursContactClient = e.ProjetContactClient.Where(p => p.DateDebut <= DateTime.Now && (p.DateFin == null || p.DateFin >= DateTime.Now)).Count()
            };
        }
        #endregion
    }
}
