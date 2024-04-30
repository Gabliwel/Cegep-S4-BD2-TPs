
using System;
using System.ComponentModel.DataAnnotations.Schema;


namespace ProjetsORM.Entites
{
    [Table("PROJET")]
    public class Projet
    {
        #region Propriétés
        #endregion Propriétés
        public string NomProjet { get; set; }

        public DateTime? DateDebut { get; set; }

        public DateTime? DateFin { get; set; }

        public decimal? Budget { get; set; }

        #region Clés étrangères
        #endregion Clés étrangères

        public string NomClient { get; set; }

        public short NoGestionnaire { get; set; }

        public short? NoContactClient { get; set; }

        #region Propriétés de navigation 
        #endregion Propriétés de navigation 

        [ForeignKey("NomClient")]
        public virtual Client Client { get; set; }

        [ForeignKey("NoGestionnaire")]
        public virtual Employe Gestionnaire { get; set; }

        [ForeignKey("NoContactClient")]
        public virtual Employe ContactClient { get; set; }

        #region Constructeur
        #endregion Constructeur
    }
}
