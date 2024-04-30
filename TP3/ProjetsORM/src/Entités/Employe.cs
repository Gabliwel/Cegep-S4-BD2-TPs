
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;


namespace ProjetsORM.Entites
{
    [Table("EMPLOYE")]
    public class Employe
    {
        #region Propriétés
        #endregion Propriétés

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public short NoEmploye { get; set; }

        public decimal NAS { get; set; }

        public string Nom { get; set; }

        public string Prenom { get; set; }

        public DateTime? DateNaissance { get; set; }

        public DateTime DateEmbauche { get; set; }

        public decimal? Salaire { get; set; }

        public decimal? TelephoneBureau { get; set; }

        public string Adresse { get; set; }

        #region Clés étrangères
        #endregion Clés étrangères

        public short? NoSuperviseur { get; set; }

        #region Propriétés de navigation 
        #endregion Propriétés de navigation 

        [ForeignKey("NoSuperviseur")]
        public virtual Employe Superviseur { get; set; }

        public virtual ICollection<Employe> SousSupervision { get; set; }

        public virtual ICollection<Projet> ProjetGestionnaire { get; set; }

        public virtual ICollection<Projet> ProjetContactClient { get; set; }

        #region Constructeur
        #endregion Constructeur

        public Employe()
        {
            SousSupervision = new List<Employe>();
            ProjetGestionnaire = new List<Projet>();
            ProjetContactClient = new List<Projet>();
        }
    }
}

