

using Microsoft.EntityFrameworkCore;
using ProjetsORM.EntiteDTOs;
using ProjetsORM.Entites;
using ProjetsORM.Persistence;
using System;
using System.Collections.Generic;
using Xunit;

namespace ProjetsORM.AccesDonnees
{
    public class EFEmployeRepositoryTest
    {
        private EFClientRepository repoClient;
        private EFEmployeRepository repoEmp;
        private EFProjetRepository repoProjet;

        private void SetUp()
        {
            DbContextOptionsBuilder<ProjetsORMContexte> builder = new DbContextOptionsBuilder<ProjetsORMContexte>();
            builder.UseInMemoryDatabase(databaseName: "testEMPLOYE_db");
            ProjetsORMContexte contexte = new ProjetsORMContexte(builder.Options);
            repoClient = new EFClientRepository(contexte);
            repoEmp = new EFEmployeRepository(contexte);
            repoProjet = new EFProjetRepository(contexte);
        }

        // MÉTHODE **** ObtenirEmploye ***** //
        [Fact]
        public void ObtenirEmploye_QuandEmployeExistePas_LanceException()
        {
            SetUp();
            Employe titi = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "Titi", DateNaissance = Convert.ToDateTime("1977-10-10"),
                DateEmbauche = Convert.ToDateTime("2007-10-10"), Salaire = 123456, TelephoneBureau = 4189991111, Adresse = "jsp"};
            Assert.Throws<ArgumentException>(() => repoEmp.ObtenirEmploye(titi.NoEmploye));
        }

        [Fact]
        public void ObtenirEmploye_QuandEmployeExiste()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateNaissance = Convert.ToDateTime("1977-10-10"),  DateEmbauche = Convert.ToDateTime("2007-10-10"),
                Salaire = 123456, TelephoneBureau = 4189991111, Adresse = "911 rue Jsp", Superviseur = serge };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);

            Employe employeTiti = repoEmp.ObtenirEmploye(titi.NoEmploye);
            Employe employeSerge = repoEmp.ObtenirEmploye(serge.NoEmploye);

            Assert.Same(titi, employeTiti);
            Assert.Same(serge, employeSerge);
        }

        // MÉTHODE **** RechercherTousLesSuperviseurs ***** //
        [Fact]
        public void RechercherTousLesSuperviseurs_QuandAucunSupervisuerExiste_RetourneUneListeVide()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp",  Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            repoEmp.AjouterEmploye(serge);
            ICollection<Employe> listeSuperviseur = repoEmp.RechercherTousLesSuperviseurs();
            Assert.Empty(listeSuperviseur);
        }

        [Fact]
        public void RechercherTousLesSuperviseurs_QuandSupervisuerExiste()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            Employe bob = new Employe { NAS = 1, Nom = "Jsp", Prenom = "Bob", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = titi };
            Employe roger = new Employe { NAS = 911, Nom = "Jsp", Prenom = "Roger", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe gontrant = new Employe { NAS = 111111, Nom = "Jsp", Prenom = "Gontrant", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = titi };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);
            repoEmp.AjouterEmploye(bob);
            repoEmp.AjouterEmploye(roger);
            repoEmp.AjouterEmploye(gontrant);

            ICollection<Employe> expectedSuperviseurs = new List<Employe> { serge, titi };
            ICollection<Employe> superviseurs = repoEmp.RechercherTousLesSuperviseurs();

            Assert.Equal(expectedSuperviseurs, superviseurs);
        }

        // MÉTHODE **** RechercherEmployesSansSuperviseur ***** //
        [Fact]
        public void RechercherEmployesSansSuperviseur_QuandAucunEmployeSansSuperviseur_RetourneUneListeVide()
        {
            SetUp();
            ICollection<Employe> listeEmp = repoEmp.RechercherEmployesSansSuperviseur();
            Assert.Empty(listeEmp);
        }

        [Fact]
        public void RechercherEmployesSansSuperviseur_QuandEmployeSansSuperviseur()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            Employe bob = new Employe { NAS = 1, Nom = "Jsp", Prenom = "Bob", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = titi };
            Employe roger = new Employe { NAS = 911, Nom = "Jsp", Prenom = "Roger", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe gontrant = new Employe { NAS = 111111, Nom = "Jsp", Prenom = "Gontrant", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = titi };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);
            repoEmp.AjouterEmploye(bob);
            repoEmp.AjouterEmploye(roger);
            repoEmp.AjouterEmploye(gontrant);

            ICollection<Employe> expectedEmp = new List<Employe> { serge, roger };
            ICollection<Employe> emp = repoEmp.RechercherEmployesSansSuperviseur();

            Assert.Equal(expectedEmp, emp);
        }

        // MÉTHODE **** ObtenirInformationEmploye ***** //
        [Fact]
        public void ObtenirInformationEmploye_QuandNoEmployeEstNonValide_LanceException()
        {
            SetUp();
            Employe titi = new Employe
            {
                NAS = 123456789,
                Nom = "Jsp",
                Prenom = "Titi",
                DateNaissance = Convert.ToDateTime("1977-10-10"),
                DateEmbauche = Convert.ToDateTime("2007-10-10"),
                Salaire = 123456,
                TelephoneBureau = 4189991111,
                Adresse = "jsp"
            };
            Assert.Throws<ArgumentException>(() => repoEmp.ObtenirInformationEmploye(titi.NoEmploye));
        }

        [Fact]
        public void ObtenirInformationEmploye_QuandNoEmployeEsValideEtAucunProjetEtRoleDeSuperviseur()
        {
            SetUp();
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            repoEmp.AjouterEmploye(titi);

            InfosTravailEmploye info = repoEmp.ObtenirInformationEmploye(titi.NoEmploye);
            InfosTravailEmploye expectedInfo = new InfosTravailEmploye { NoEmploye = titi.NoEmploye, Nom = titi.Nom, Prenom = titi.Prenom, NbEmployesSupervises = 0, NbProjetEncoursGeres = 0, NbProjetEncoursContactClient = 0 };

            Assert.Equal(info, expectedInfo);
        }

        [Fact]
        public void ObtenirInformationEmploye_QuandNoEmployeEstValideEtAucunProjet()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);

            titi.SousSupervision.Add(serge);

            InfosTravailEmploye info = repoEmp.ObtenirInformationEmploye(titi.NoEmploye);

            InfosTravailEmploye expectedInfo = new InfosTravailEmploye { NoEmploye = titi.NoEmploye, Nom = titi.Nom, Prenom = titi.Prenom, NbEmployesSupervises = 1, NbProjetEncoursGeres = 0, NbProjetEncoursContactClient = 0 };

            Assert.Equal(info, expectedInfo);
        }

        [Fact]
        public void ObtenirInformationEmploye_QuandNoEmployeEstValideEtProjetEnCours()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);

            titi.SousSupervision.Add(serge);

            Client client = new Client { NomClient = "ABCDEFG", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(client);

            Projet projet1 = new Projet { NomProjet = "Projet#1", NomClient = client.NomClient, Gestionnaire = titi, ContactClient = titi, DateDebut = Convert.ToDateTime("2007-10-10"), DateFin = Convert.ToDateTime("2032-10-10") };
            Projet projet2 = new Projet { NomProjet = "Projet#2", NomClient = client.NomClient, Gestionnaire = serge, ContactClient = titi, DateDebut = Convert.ToDateTime("2007-10-10"), DateFin = null };

            titi.ProjetGestionnaire.Add(projet1);
            titi.ProjetContactClient.Add(projet1);
            titi.ProjetContactClient.Add(projet2);

            InfosTravailEmploye info = repoEmp.ObtenirInformationEmploye(titi.NoEmploye);
            InfosTravailEmploye expectedInfo = new InfosTravailEmploye { NoEmploye = titi.NoEmploye, Nom = titi.Nom, Prenom = titi.Prenom, NbEmployesSupervises = 1, NbProjetEncoursGeres = 1, NbProjetEncoursContactClient = 2 };

            Assert.Equal(info, expectedInfo);
        }

        [Fact]
        public void ObtenirInformationEmploye_QuandNoEmployeEstValideEtProjetPasEnCours()
        {
            SetUp();
            Employe serge = new Employe { NAS = 123456789, Nom = "Jsp", Prenom = "serge", DateEmbauche = Convert.ToDateTime("2007-10-10") };
            Employe titi = new Employe { NAS = 123, Nom = "Jsp", Prenom = "Titi", DateEmbauche = Convert.ToDateTime("2007-10-10"), Superviseur = serge };
            repoEmp.AjouterEmploye(serge);
            repoEmp.AjouterEmploye(titi);

            titi.SousSupervision.Add(serge);

            Client client = new Client { NomClient = "ABCDEFG", NoEnregistrement = 123, Ville = "QC", CodePostal = "A2A1B1" };
            repoClient.AjouterClient(client);

            Projet projet1 = new Projet { NomProjet = "Projet#1", NomClient = client.NomClient, Gestionnaire = titi, ContactClient = titi, DateDebut = null };
            Projet projet2 = new Projet { NomProjet = "Projet#2", NomClient = client.NomClient, Gestionnaire = serge, ContactClient = titi, DateDebut = Convert.ToDateTime("2007-10-10"), DateFin = Convert.ToDateTime("2022-05-11") };

            titi.ProjetGestionnaire.Add(projet1);
            titi.ProjetContactClient.Add(projet1);
            titi.ProjetContactClient.Add(projet2);

            InfosTravailEmploye info = repoEmp.ObtenirInformationEmploye(titi.NoEmploye);
            InfosTravailEmploye expectedInfo = new InfosTravailEmploye { NoEmploye = titi.NoEmploye, Nom = titi.Nom, Prenom = titi.Prenom, NbEmployesSupervises = 1, NbProjetEncoursGeres = 0, NbProjetEncoursContactClient = 0 };

            Assert.Equal(info, expectedInfo);
        }
    }
}
