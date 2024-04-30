using System;
using Microsoft.EntityFrameworkCore;
using ProjetsORM.Entites;

namespace ProjetsORM.Persistence
{
    public class ProjetsORMContexte : DbContext
    {
        #region Propriétés DBSet
        #endregion Propriétés DBSet
        public virtual DbSet<Employe> Employes { get; set; }
        public virtual DbSet<Projet> Projets { get; set; }
        public virtual DbSet<Client> Clients { get; set; }

        #region Constructeur
        public ProjetsORMContexte(DbContextOptions<ProjetsORMContexte> options) : base(options)
        {
            Database.EnsureDeleted();
            Database.EnsureCreated();
        }
        #endregion Constructeur

        protected override void OnModelCreating(ModelBuilder builder)
        {
            BuildEmploye(builder);
            BuildProjet(builder);
            BuildClient(builder);
        }

        private static void BuildEmploye(ModelBuilder builder)
        {
            //Clé primaire
            builder.Entity<Employe>()
                   .HasKey(e => e.NoEmploye);
            //Index uniques
            builder.Entity<Employe>()
                   .HasIndex(e => e.NAS)
                   .IsUnique();
            //Clés étrangeres
            builder.Entity<Employe>()
                   .HasOne(e => e.Superviseur)
                   .WithMany(superviseur => superviseur.SousSupervision)
                   .OnDelete(DeleteBehavior.Restrict);
            //Colonnes
            builder.Entity<Employe>()
                   .Property(e => e.NAS)
                   .IsRequired()
                   .HasColumnType("decimal(9,0)");
            builder.Entity<Employe>()
                  .Property(e => e.Nom)
                  .IsRequired()
                  .HasColumnType("varchar(10)");
            builder.Entity<Employe>()
                  .Property(e => e.Prenom)
                  .IsRequired()
                  .HasColumnType("varchar(10)");
            builder.Entity<Employe>()
                  .Property(e => e.DateEmbauche)
                  .IsRequired();
            builder.Entity<Employe>()
                   .Property(e => e.Salaire)
                   .HasColumnType("decimal(6,0)");
            builder.Entity<Employe>()
                   .Property(e => e.TelephoneBureau)
                   .HasColumnType("decimal(10,0)");
            builder.Entity<Employe>()
                  .Property(e => e.Adresse)
                  .HasColumnType("varchar(15)");
        }

        private static void BuildProjet(ModelBuilder builder)
        {
            //Clé primaire 
            builder.Entity<Projet>()
                   .HasKey(p => new { p.NomProjet, p.NomClient });
            //Clés étrangeres
            builder.Entity<Projet>()
                   .HasOne(p => p.Client)
                   .WithMany(client => client.Projets)
                   .OnDelete(DeleteBehavior.Restrict);
            builder.Entity<Projet>()
                   .HasOne(p => p.Gestionnaire)
                   .WithMany(gestionnaire => gestionnaire.ProjetGestionnaire)
                   .OnDelete(DeleteBehavior.Restrict);
            builder.Entity<Projet>()
                   .HasOne(p => p.ContactClient)
                   .WithMany(contact => contact.ProjetContactClient)
                   .OnDelete(DeleteBehavior.Restrict);
            //Colonnes
            builder.Entity<Projet>()
                   .Property(p => p.NomClient)
                   .IsRequired()
                   .HasColumnType("varchar(10)");
            builder.Entity<Projet>()
                   .Property(p => p.NomProjet)
                   .IsRequired()
                   .HasColumnType("varchar(10)");
            builder.Entity<Projet>()
                   .Property(p => p.Budget)
                   .HasColumnType("decimal(6,0)");
            builder.Entity<Projet>()
                   .Property(p => p.NoGestionnaire)
                   .IsRequired();
        }

        private static void BuildClient(ModelBuilder builder)
        {
            //Clé primaire 
            builder.Entity<Client>()
                   .HasKey(c => c.NomClient);
            //Index uniques
            builder.Entity<Client>()
                   .HasIndex(c => c.NoEnregistrement)
                   .IsUnique();
            //Colonnes
            builder.Entity<Client>()
                   .Property(c => c.NomClient)
                   .IsRequired()
                   .HasColumnType("varchar(10)");
            builder.Entity<Client>()
                   .Property(c => c.NoEnregistrement)
                   .IsRequired()
                   .HasColumnType("smallint");
            builder.Entity<Client>()
                   .Property(c => c.Rue)
                   .HasColumnType("varchar(10)");
            builder.Entity<Client>()
                   .Property(c => c.Ville)
                   .IsRequired()
                   .HasColumnType("varchar(10)");
            builder.Entity<Client>()
                   .Property(c => c.CodePostal)
                   .IsRequired()
                   .HasColumnType("char(6)");
            builder.Entity<Client>()
                   .Property(c => c.Telephone)
                   .HasColumnType("decimal(10,0)");
        }
    }
}
