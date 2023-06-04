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

            CreateMap<Event, EventResponse>().ReverseMap();

            CreateMap<Event, EventResponse>()
                .ForMember(dest => dest.Images, opt => opt.MapFrom(src => src.EventImages.Select(ei => ei.Image)));

            CreateMap<Image, ImageResponse>();



            CreateMap<EventRequest, Event>().ReverseMap();

            CreateMap<EcoViolation, EcoViolationResponse>().ReverseMap();
            CreateMap<EcoViolationRequest, EcoViolation>().ReverseMap();

            CreateMap<GreenIsland, GreenIslandResponse>().ReverseMap();
            CreateMap<GreenIslandRequest, GreenIsland>().ReverseMap();

        }
    }
}
