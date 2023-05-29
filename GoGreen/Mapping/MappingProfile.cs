using AutoMapper;
using GoGreen.Requests;
using GoGreen.Responses;
using GoGreen.Models;

namespace GoGreen.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            CreateMap<Event, EventResponse>();

        }
    }
}
