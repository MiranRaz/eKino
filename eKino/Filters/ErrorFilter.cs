using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace eKino.Filters
{
    public class ErrorFilter : ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            context.ModelState.AddModelError("ERROR", "Server side error");

            var list = context.ModelState.Where(x => x.Value.Errors.Count() > 0)
                .ToDictionary(x=>x.Key,y =>y.Value.Errors
                .Select(z=>z.ErrorMessage));

            context.Result = new JsonResult(new { errors = list} );
        }
    }
}