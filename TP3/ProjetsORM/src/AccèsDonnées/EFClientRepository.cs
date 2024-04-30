using ProjetsORM.Entites;
using ProjetsORM.EntiteDTOs;
using ProjetsORM.Persistence;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ProjetsORM.AccesDonnees
{
    class EFClientRepository
    {
        #region Champs
        #endregion

        private ProjetsORMContexte contexte;

        #region Constructeur
        public EFClientRepository(ProjetsORMContexte contexte)
        {
            this.contexte = contexte;
        }
        #endregion

        #region Méthodes
        public void AjouterClient(Client client)
        {
            contexte.Clients.Add(client);
            contexte.SaveChanges();
        }

        private void ValiderClient(string nomClient)
        {
            if (contexte.Clients.Find(nomClient) == null) { throw new ArgumentException("Le client n'existe pas"); }
        }

        public Client ObtenirClient(string nomClient)
        {
            ValiderClient(nomClient);
            return contexte.Clients.Find(nomClient);
        }

        public ICollection<Client> RechercherClientsPourUneVille(string nomVille)
        {
            return contexte.Clients.Where(c => c.Ville == nomVille).ToList();
        }

        public StatsClient ObtenirStatsPourUnClient(string nomclient)
        {
            Client c = ObtenirClient(nomclient);
            return ObtenirStatsClient(c);
        }

        public ICollection<StatsClient> CalculerStatsPourTousLesClients()
        {
            return contexte.Clients.ToList().Select(c => ObtenirStatsClient(c)).ToList();
        }

        private StatsClient ObtenirStatsClient(Client c)
        {
            return new StatsClient
            {
                NomClient = c.NomClient,
                NombreProjets = c.Projets.Count(),
                BudgetTotal = c.Projets.Sum(p => p.Budget),
                BudgetMoyen = c.Projets.Average(p => p.Budget),
                BudgetMax = c.Projets.Max(p => p.Budget)
            };
        }

        public ICollection<InfosProjetsEnCours> ObtenirInfoProjetsEnCoursPourUnClient(string nomClient)
        {
            Client c = ObtenirClient(nomClient);
            return c.Projets.Select(p =>
            new InfosProjetsEnCours
            {
                NomClient = c.NomClient,
                NomProjet = p.NomProjet,
                Budget = p.Budget,
                Gestionnaire = getEmployeTextForm(p.Gestionnaire),
                ContactClient = getEmployeTextForm(p.ContactClient)
            }).ToList();
        }

        private string getEmployeTextForm(Employe employe)
        {
            if(employe == null)
            {
                return null;
            }
            else
            {
                return "(" + employe.NoEmploye + ") " + employe.Nom + " " + employe.Prenom;
            }
        }
        #endregion

    }
}
