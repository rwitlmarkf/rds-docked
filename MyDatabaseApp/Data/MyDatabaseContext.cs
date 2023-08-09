using Microsoft.EntityFrameworkCore;

namespace MyDatabaseApp.Data
{
    public class MyDatabaseContext : DbContext
    {
        public MyDatabaseContext(DbContextOptions<MyDatabaseContext> options) : base(options)
        {
        }

        public DbSet<MyTable> MyTable { get; set; }
    }

    public class MyTable
    {
        public int Id { get; set; }
        public string Name { get; set; }
        // Add other properties that match the columns in your database
    }
}
