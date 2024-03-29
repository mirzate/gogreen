﻿using System.Collections.Generic;
using System.Threading.Tasks;
using GoGreen.Data;
using GoGreen.Requests;
using GoGreen.Models;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
using System.Security.Claims;
using GoGreen.Responses;
using Microsoft.AspNetCore.Mvc;
using NuGet.Protocol;
using Microsoft.AspNetCore.Http;

namespace GoGreen.Services
{
    public class EventService : IEventService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public EventService(ApplicationDbContext context, IMapper mapper, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _mapper = mapper;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task<(IEnumerable<EventResponse> Events, int TotalCount)> GetAllAsync(int pageIndex = 1, int pageSize = 10, string? fullTextSearch = "")
        {


            var query = _context.Events.AsQueryable();

            
            if (!string.IsNullOrEmpty(fullTextSearch))
            {
                query = query.Where(e => e.Title.Contains(fullTextSearch) || e.Description.Contains(fullTextSearch));
            }

            HttpContext httpContext = _httpContextAccessor.HttpContext;

            if (httpContext.User.Identity.IsAuthenticated)
            {
                var userId = httpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                var user = await _context.User.Include(e => e.Municipality).FirstOrDefaultAsync(u => u.Id == userId);
                query = query.Where(e => e.MunicipalityId == user.MunicipalityId);
            }

            var events = await query
                        .OrderByDescending(e => e.Id)
                        .Skip((pageIndex - 1) * pageSize)
                        .Include(e => e.EventImages)
                            .ThenInclude(ei => ei.Image)
                        .Include(e => e.Municipality)
                        .Include(e => e.EventType)
                        .Take(pageSize)
                        .ToListAsync();

            var totalCount = await query.CountAsync();

            //var eventResponses = _mapper.Map<IEnumerable<EventResponse>>(events);

            var eventResponses = events.Select(e =>
            {
                var eventResponse = _mapper.Map<EventResponse>(e);
                eventResponse.FirstImage = _mapper.Map<ImageResponse>(e.EventImages.FirstOrDefault()?.Image);
                return eventResponse;
            });

            return (eventResponses, totalCount);
        }
        public async Task<EventResponse> GetById(int id)
        {

            var data = await _context.Events
                .Include(a => a.EventType)
                .Include(a => a.Municipality)
                .Include(a => a.EventImages)
                    .ThenInclude(ei => ei.Image)
                .Include(e => e.Municipality)
                .Include(e => e.EventType)
                .FirstOrDefaultAsync(a => a.Id == id);

            if (data == null)
            {
                return null;
            }
            /*
            data.ViewCount = 1;
            await _context.SaveChangesAsync();
            */
            var eventResponse = _mapper.Map<EventResponse>(data);
            return eventResponse;
        }

        public async Task<Event> Create(EventRequest eventRequest)
        {
            
            var data = _mapper.Map<Event>(eventRequest);

            HttpContext httpContext = _httpContextAccessor.HttpContext;
            var userId = httpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            var user = await _context.User.FirstOrDefaultAsync(a => a.Id == userId);

            data.MunicipalityId = (int)user.MunicipalityId;
            data.UserId = userId;
            _context.Events.Add(data);

            await _context.SaveChangesAsync();
            var createdEvent = _mapper.Map<Event>(data);
            return createdEvent;
        }

        public async Task<EventResponse> Update(int id, EventRequest request)
        {

            /*
            HttpContext httpContext = _httpContextAccessor.HttpContext;
            var userId = httpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);


            if (string.IsNullOrEmpty(userId))
            {
                return null;
            }
            */


            var existingEvent = await _context.Events
            .Where(e => e.Id == id)
            .SingleOrDefaultAsync();

            if (existingEvent == null)
            {
                return null;
            }

                existingEvent.Title = request.Title;

                existingEvent.Description = request.Description;
   
                existingEvent.DateFrom = request.DateFrom;
            
                existingEvent.DateTo = request.DateTo;
     
                existingEvent.Active = request.Active;
      
                existingEvent.TypeId = request.TypeId;


            _context.Events.Update(existingEvent);
            await _context.SaveChangesAsync();

            var updatedEventResponse = _mapper.Map<EventResponse>(existingEvent);

            return updatedEventResponse;
        }

        public async Task<bool> Delete(int id)
        {

            var eventToDelete = await _context.Events
            .Where(e => e.Id == id)
            .SingleOrDefaultAsync();

            if (eventToDelete == null)
            {
                return false; // Event not found
            }

            await _context.EventSubscribes.Where(e => e.EventId == id).ExecuteDeleteAsync();

            _context.Events.Remove(eventToDelete);

            await _context.SaveChangesAsync();

            return true; // Event successfully deleted
        }



    }

}
