

using System;

namespace ProjetsORM.EntiteDTOs
{
    public class InfosTravailEmploye
    {
        public short NoEmploye;
        public string Nom;
        public string Prenom;
        public int NbEmployesSupervises;
        public int NbProjetEncoursGeres;
        public int NbProjetEncoursContactClient;

        public static bool operator ==(InfosTravailEmploye statsA, InfosTravailEmploye statB)
        {
            return statsA.NoEmploye == statB.NoEmploye
                && statsA.Nom == statB.Nom
                && statsA.Prenom == statB.Prenom
                && statsA.NbEmployesSupervises == statB.NbEmployesSupervises
                && statsA.NbProjetEncoursGeres == statB.NbProjetEncoursGeres
                && statsA.NbProjetEncoursContactClient == statB.NbProjetEncoursContactClient;
        }

        public static bool operator !=(InfosTravailEmploye statsA, InfosTravailEmploye statB)
        {
            return !(statsA == statB);
        }
        public override bool Equals(object o)
        {
            InfosTravailEmploye statsEtud = (InfosTravailEmploye)o;
            return this == statsEtud;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(NoEmploye, Nom, Prenom, NbEmployesSupervises, NbProjetEncoursGeres, NbProjetEncoursContactClient);
        }
    }
}
