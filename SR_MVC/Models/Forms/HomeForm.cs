﻿using Microsoft.AspNetCore.Mvc.Rendering;
using SR_BLL.Data;
using SR_MVC.Infrastructure.Validation;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace SR_MVC.Models.Forms
{
    public class HomeForm

    {

        public static DateTime now = DateTime.Now;

        [Required]
        [DisplayName("Destination planet:")]
        //[PlanetIdValidationAttribute]
        public string Name { get; set; }
        public IEnumerable<SelectListItem> Planets { get; set; }
        public int id { get; set; }

        [Required]
        [DisplayName("Jupiter stop-over:")]
        public bool Stopover { get; set; }

        [Required]
        [DisplayName("Departure date:")]
        [Range(typeof(DateTime), "1/1/1999", "1/1/2033", ErrorMessage = "Date is out of range!")]
        public DateTime DateA { get; set; }

        [Required]
        [DisplayName("Return date:")]
        public DateTime DateB { get; set; }

        [Required]
        [DisplayName("1st class option:")]
        public bool Is_1stclass { get; set; }
    };
}
