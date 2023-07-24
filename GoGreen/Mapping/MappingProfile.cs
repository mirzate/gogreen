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
            CreateMap<EventRequest, Event>().ReverseMap();

            CreateMap<EcoViolation, EcoViolationResponse>().ReverseMap();
            CreateMap<EcoViolationRequest, EcoViolation>().ReverseMap();

            
            CreateMap<GreenIsland, GreenIslandResponse>().ReverseMap();
            CreateMap<GreenIslandRequest, GreenIsland>().ReverseMap();

            CreateMap<Image, ImageResponse>();

            CreateMap<Event, EventResponse>()
             .ForMember(dest => dest.Images, opt => opt.MapFrom(src => src.EventImages.Select(ei => ei.Image)));

            CreateMap<GreenIsland, GreenIslandResponse>()
            .ForMember(dest => dest.Images, opt => opt.MapFrom(src => src.GreenIslandImages.Select(ei => ei.Image)));

            CreateMap<EcoViolation, EcoViolationResponse>()
            .ForMember(dest => dest.Images, opt => opt.MapFrom(src => src.EcoViolationImages.Select(ei => ei.Image)));

            /*
            CreateMap<EcoViolation, EcoViolationResponse>()
                .ForMember(dest => dest.EcoViolationStatus, opt => opt.MapFrom(src => src.EcoViolationStatus));
            */
        }
    }
}
