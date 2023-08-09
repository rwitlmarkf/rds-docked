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
