#!/bin/bash

# Create a new ASP.NET Core Web Application project
dotnet new webapp -n MyDatabaseApp
cd MyDatabaseApp

# Add necessary NuGet package for SQL Server
dotnet add package Microsoft.EntityFrameworkCore.SqlServer

# Create Data directory for DbContext and Models
mkdir Data

# Create the DbContext class
cat > Data/MyDatabaseContext.cs <<EOL
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
EOL

# Update Startup.cs
cat > Startup.cs <<EOL
using Microsoft.Extensions.DependencyInjection;
using MyDatabaseApp.Data;

public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddDbContext<MyDatabaseContext>(options =>
            options.UseSqlServer(Configuration.GetConnectionString("MyDatabaseConnection")));

        // Other services...
    }

    // Rest of the code...
}
EOL

# Add the connection string to appsettings.json
echo '  "ConnectionStrings": {
    "MyDatabaseConnection": "Your-Connection-String-Here"
  },' >> appsettings.json

# Create Razor page to list the contents
mkdir Pages
cat > Pages/Index.cshtml.cs <<EOL
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using MyDatabaseApp.Data;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MyDatabaseApp.Pages
{
    public class IndexModel : PageModel
    {
        private readonly MyDatabaseContext _context;

        public IndexModel(MyDatabaseContext context)
        {
            _context = context;
        }

        public IList<MyTable> MyTable { get;set; }

        public async Task OnPostAsync()
        {
            MyTable = await _context.MyTable.ToListAsync();
        }
    }
}
EOL

cat > Pages/Index.cshtml <<EOL
@page
@model IndexModel
<!DOCTYPE html>
<html>
<head>
    <title>My Table</title>
</head>
<body>
    <form method="post">
        <input type="submit" value="OK" />
    </form>

    @if (Model.MyTable != null)
    {
        <table>
            <tr>
                <th>Id</th>
                <th>Name</th>
                <!-- Other columns -->
            </tr>
            @foreach (var item in Model.MyTable)
            {
                <tr>
                    <td>@item.Id</td>
                    <td>@item.Name</td>
                    <!-- Other values -->
                </tr>
            }
        </table>
    }
</body>
</html>
EOL

echo "Project has been created. You can run it using 'dotnet run' inside the MyDatabaseApp directory."

