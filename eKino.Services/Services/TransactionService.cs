using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using eKino.Model;
using eKino.Services.Interfaces;

namespace eKino.Services.Services
{
    public class TransactionService : BaseCRUDService<Model.Transaction, Database.Transaction, TransactionSearchObject, TransactionUpsertRequest, TransactionUpsertRequest>, ITransactionService
    {
        public TransactionService(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Transaction> AddFilter(IQueryable<Database.Transaction> query, TransactionSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.UserId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.UserId == search.UserId);
            }
            
            if (search?.ReservationId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.ReservationId == search.ReservationId);
            }
            
            if (search?.DateOfTransaction != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DateOfTransaction == search.DateOfTransaction.Value.Date);
            }

            return filteredQuery;
        }

    }
}