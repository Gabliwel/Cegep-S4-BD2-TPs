using System;

namespace ProjetsORM.EntiteDTOs
{
	public class StatsClient
    {
        public string NomClient;
        public int NombreProjets;
        public decimal? BudgetTotal;
        public decimal? BudgetMoyen;
        public decimal? BudgetMax;

        public static bool operator ==(StatsClient statsA, StatsClient statB)
        {
            return statsA.NomClient == statB.NomClient
                && statsA.NombreProjets == statB.NombreProjets
                && statsA.BudgetTotal == statB.BudgetTotal
                && statsA.BudgetMoyen == statB.BudgetMoyen
                && statsA.BudgetMax == statB.BudgetMax;
        }

        public static bool operator !=(StatsClient statsA, StatsClient statB)
        {
            return !(statsA == statB);
        }
        public override bool Equals(object o)
        {
            StatsClient statsEtud = (StatsClient)o;
            return this == statsEtud;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(NomClient, NombreProjets, BudgetTotal, BudgetMoyen, BudgetMax);
        }
    }
}
