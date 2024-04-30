

using Microsoft.EntityFrameworkCore;
using ProjetsORM.EntiteDTOs;
using ProjetsORM.Entites;
using ProjetsORM.Persistence;
using System;
using System.Collections.Generic;
using Xunit;

namespace ProjetsORM.AccesDonnees
{
    public class EFClientRepositoryTest
    {
        private EFClientRepository repoClient;
        private EFEmployeRepository repoEmp;
        private EFProjetRepository repoProjet;

        private void SetUp()
        {
            DbContextOptionsBuilder<ProjetsORMContexte> builder = new DbContextOptionsBuilder<ProjetsORMContexte>();
            builder.UseInMemoryDatabase(databaseName: "testCLIENT_db");
            ProjetsORMContexte contexte = new ProjetsORMContexte(builder.Options);
            repoClient = new EFClientRepository(contexte);
            repoEmp = new EFEmployeRepository(contexte);
            repoProjet = new EFProjetRepository(contexte);
        }

        // MÉTHODE **** ObtenirClient ***** //
        [Fact]
        public void ObtenirClient_QuandClientExistePas_LanceException()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            Assert.Throws<ArgumentException>(() => repoClient.ObtenirClient(bob.NomClient));
        }

        [Fact]
        public void ObtenirClient_QuandClientExiste()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            Client lilalou = new Client { NomClient = "Lilalou", NoEnregistrement = 911, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);
            repoClient.AjouterClient(lilalou);

            Client clientBob = repoClient.ObtenirClient(bob.NomClient);
            Client clientLilalou = repoClient.ObtenirClient(lilalou.NomClient);

            Assert.Same(bob, clientBob);
            Assert.Same(lilalou, clientLilalou);
        }

        // MÉTHODE **** RechercherClientsPourUneVille ***** //
        [Fact]
        public void RechercherClientsPourUneVille_QuandAucunClient_RetourneListeVide()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            ICollection<Client> lstClient = repoClient.RechercherClientsPourUneVille(bob.Ville);
            Assert.Empty(lstClient);
        }

        [Fact]
        public void RechercherClientsPourUneVille_QuandAucunClientAvecLaVilleDonne_RetourneListeVide()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);
            ICollection<Client> lstClient = repoClient.RechercherClientsPourUneVille(bob.Ville + "abc");
            Assert.Empty(lstClient);
        }

        [Fact]
        public void RechercherClientsPourUneVille_QuandPlusieursClientsAvecLaVilleDonne()
        {
            SetUp();
            Client roger = new Client { NomClient = "Roger", NoEnregistrement = 321, Ville = "Q", CodePostal = "A2A1B1" };
            Client lilalou = new Client { NomClient = "Lilalou", NoEnregistrement = 911, Ville = "QC", CodePostal = "A2A1B1" };
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(roger);
            repoClient.AjouterClient(lilalou);
            repoClient.AjouterClient(bob);
            ICollection<Client> expectedLstClient = new List<Client> { lilalou, bob };
            ICollection<Client> lstClient = repoClient.RechercherClientsPourUneVille(bob.Ville);
            Assert.Equal(expectedLstClient, lstClient);
        }

        // MÉTHODE **** ObtenirStatsPourUnClient ***** //
        [Fact]
        public void ObtenirStatsPourUnClient_QuandClientExistePas_LanceException()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            Assert.Throws<ArgumentException>(() => repoClient.ObtenirStatsPourUnClient(bob.NomClient));
        }

        [Fact]
        public void ObtenirStatsPourUnClient_QuandClientNaAucunProjet()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);
            StatsClient stats = repoClient.ObtenirStatsPourUnClient(bob.NomClient);
            StatsClient expecedStats = new StatsClient { NomClient = bob.NomClient, NombreProjets = 0, BudgetTotal = 0, BudgetMoyen = null, BudgetMax = null };

            Assert.Equal(expecedStats, stats);
        }

        [Fact]
        public void ObtenirStatsPourUnClient_QuandClientAPlusieursProjetsSansBudget()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);

            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            Projet projet1 = new Projet { NomProjet = "Projet#111", NomClient = bob.NomClient, Gestionnaire = titi };
            Projet projet2 = new Projet { NomProjet = "Projet#222", NomClient = bob.NomClient, Gestionnaire = titi };

            bob.Projets.Add(projet1);
            bob.Projets.Add(projet2);

            StatsClient stats = repoClient.ObtenirStatsPourUnClient(bob.NomClient);
            StatsClient expecedStats = new StatsClient { NomClient = bob.NomClient, NombreProjets = 2, BudgetTotal = 0, BudgetMoyen = null, BudgetMax = null };

            Assert.Equal(expecedStats, stats);
        }

        [Fact]
        public void ObtenirStatsPourUnClient_QuandClientAPlusieursProjetsAvecBudget()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);

            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            Projet projet1 = new Projet { NomProjet = "Projet#111", NomClient = bob.NomClient, Gestionnaire = titi, Budget = 10000 };
            Projet projet2 = new Projet { NomProjet = "Projet#222", NomClient = bob.NomClient, Gestionnaire = titi, Budget = 100000 };

            bob.Projets.Add(projet1);
            bob.Projets.Add(projet2);

            StatsClient stats = repoClient.ObtenirStatsPourUnClient(bob.NomClient);
            StatsClient expecedStats = new StatsClient { NomClient = bob.NomClient, NombreProjets = 2, BudgetTotal = projet1.Budget + projet2.Budget, BudgetMoyen = (projet1.Budget + projet2.Budget)/2, BudgetMax = projet2.Budget };

            Assert.Equal(expecedStats, stats);
        }

        // MÉTHODE **** CalculerStatsPourTousLesClients ***** //
        [Fact]
        public void CalculerStatsPourTousLesClients_QuandAucunClient_RetourneUneListeVide()
        {
            SetUp();
            ICollection<StatsClient> stats = repoClient.CalculerStatsPourTousLesClients();
            Assert.Empty(stats);
        }

        [Fact]
        public void CalculerStatsPourTousLesClients_AvecUnClientEtAucunProjet()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);

            ICollection<StatsClient> stats = repoClient.CalculerStatsPourTousLesClients();
            StatsClient expecedStat1 = new StatsClient { NomClient = bob.NomClient, NombreProjets = 0, BudgetTotal = 0, BudgetMoyen = null, BudgetMax = null };
            ICollection<StatsClient> expectedStats = new List<StatsClient> { expecedStat1 };

            Assert.Equal(expectedStats, stats);
        }

        [Fact]
        public void CalculerStatsPourTousLesClients_AvecPlusieursClientsEtProjets()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);
            Client jsp = new Client { NomClient = "Jsp", NoEnregistrement = 321, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(jsp);

            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            Projet projet1 = new Projet { NomProjet = "Projet#111", NomClient = bob.NomClient, Gestionnaire = titi, Budget = 10000 };
            Projet projet2 = new Projet { NomProjet = "Projet#222", NomClient = bob.NomClient, Gestionnaire = titi, Budget = 100000 };
            Projet projet3 = new Projet { NomProjet = "Projet#1", NomClient = jsp.NomClient, Gestionnaire = titi, Budget = 1 };
            Projet projet4 = new Projet { NomProjet = "Projet#2", NomClient = jsp.NomClient, Gestionnaire = titi, Budget = 2 };
            Projet projet5 = new Projet { NomProjet = "Projet#3", NomClient = jsp.NomClient, Gestionnaire = titi, Budget = 3 };

            bob.Projets.Add(projet1);
            bob.Projets.Add(projet2);
            jsp.Projets.Add(projet3);
            jsp.Projets.Add(projet4);
            jsp.Projets.Add(projet5);

            ICollection<StatsClient> stats = repoClient.CalculerStatsPourTousLesClients();
            StatsClient expecedStats1 = new StatsClient { NomClient = bob.NomClient, NombreProjets = 2, BudgetTotal = projet1.Budget + projet2.Budget, BudgetMoyen = (projet1.Budget + projet2.Budget) / 2, BudgetMax = projet2.Budget };
            StatsClient expecedStats2 = new StatsClient { NomClient = jsp.NomClient, NombreProjets = 3, BudgetTotal = projet3.Budget + projet4.Budget + projet5.Budget, BudgetMoyen = (projet3.Budget + projet4.Budget + projet5.Budget) / 3, BudgetMax = projet5.Budget };
            ICollection<StatsClient> expectedStats = new List<StatsClient> { expecedStats1, expecedStats2 };

            Assert.Equal(expectedStats, stats);
        }

        // MÉTHODE **** ObtenirInfoProjetsEnCoursPourUnClient ***** //
        [Fact]
        public void ObtenirInfoProjetsEnCoursPourUnClient_QuandClientExistePas_LanceException()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            Assert.Throws<ArgumentException>(() => repoClient.ObtenirInfoProjetsEnCoursPourUnClient(bob.NomClient));
        }

        [Fact]
        public void ObtenirInfoProjetsEnCoursPourUnClient_QuandClientAAucunProjet_RetourneUneListeVide()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);
            ICollection<InfosProjetsEnCours> info = repoClient.ObtenirInfoProjetsEnCoursPourUnClient(bob.NomClient);
            Assert.Empty(info);
        }

        [Fact]
        public void ObtenirInfoProjetsEnCoursPourUnClient_QuandClientAProjetSansBudgetEtContact()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);

            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            Projet projet1 = new Projet { NomProjet = "Projet#3", NomClient = bob.NomClient, Gestionnaire = titi, ContactClient = null };
            bob.Projets.Add(projet1);

            ICollection<InfosProjetsEnCours> info = repoClient.ObtenirInfoProjetsEnCoursPourUnClient(bob.NomClient);
            InfosProjetsEnCours expectedInfo1 = new InfosProjetsEnCours { NomClient = bob.NomClient, NomProjet = projet1.NomProjet, Budget = null, Gestionnaire = "(" + titi.NoEmploye + ") " + titi.Nom + " " + titi.Prenom, ContactClient = null };
            ICollection<InfosProjetsEnCours> expectedInfo = new List<InfosProjetsEnCours> { expectedInfo1 };

            Assert.Equal(info, expectedInfo);
        }

        [Fact]
        public void ObtenirInfoProjetsEnCoursPourUnClient_QuandClientAPlusieursProjets()
        {
            SetUp();
            Client bob = new Client { NomClient = "Bob", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(bob);

            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            Projet projet1 = new Projet { NomProjet = "Projet#1", NomClient = bob.NomClient, Gestionnaire = titi, ContactClient = titi, Budget = 5 };
            bob.Projets.Add(projet1);
            Projet projet2 = new Projet { NomProjet = "Projet#2", NomClient = bob.NomClient, Gestionnaire = titi };
            bob.Projets.Add(projet2);

            ICollection<InfosProjetsEnCours> info = repoClient.ObtenirInfoProjetsEnCoursPourUnClient(bob.NomClient);
            InfosProjetsEnCours expectedInfo1 = new InfosProjetsEnCours { NomClient = bob.NomClient, NomProjet = projet1.NomProjet, Budget = projet1.Budget, Gestionnaire = "(" + titi.NoEmploye + ") " + titi.Nom + " " + titi.Prenom, ContactClient = "(" + titi.NoEmploye + ") " + titi.Nom + " " + titi.Prenom };
            InfosProjetsEnCours expectedInfo2 = new InfosProjetsEnCours { NomClient = bob.NomClient, NomProjet = projet2.NomProjet, Budget = projet2.Budget, Gestionnaire = "(" + titi.NoEmploye + ") " + titi.Nom + " " + titi.Prenom, ContactClient = null };
            ICollection<InfosProjetsEnCours> expectedInfo = new List<InfosProjetsEnCours> { expectedInfo1, expectedInfo2 };

            Assert.Equal(info, expectedInfo);
        }
    }
}
