using System;
namespace eKino.Model
{
    public class Director
    {
        public int DirectorId { get; set; }
        public string FullName { get; set; } = null!;
        public string Biography { get; set; } = null!;
        public byte[]? Photo { get; set; }
        public override string ToString()
        {
            return FullName;
        }
    }
}

