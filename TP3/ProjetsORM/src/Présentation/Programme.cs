using Microsoft.EntityFrameworkCore;
using ProjetsORM.AccesDonnees;
using ProjetsORM.Persistence;
using System;
using System.Configuration;

namespace ProjetsORM.Presentation
{
    class Program
    {
        static void Main(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ProjetsORMContexte>();
            optionsBuilder.UseSqlServer(ConfigurationManager.ConnectionStrings["bdProjetsORMConnectionString"].ConnectionString);
            ProjetsORMContexte contexte = new ProjetsORMContexte(optionsBuilder.Options);

            //Instanciation des repositories
            EFClientRepository clientRepo = new EFClientRepository(contexte);
            EFEmployeRepository employeRepo = new EFEmployeRepository(contexte);
            EFProjetRepository projetRepo = new EFProjetRepository(contexte);


            Console.WriteLine("Démarrage...");
            Console.WriteLine("Appuyez sur une touche pour terminer...");
            Console.ReadKey();

        }
    }
}
