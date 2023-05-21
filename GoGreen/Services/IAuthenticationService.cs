using GoGreen.Requests;

namespace GoGreen.Services
{
    public interface IAuthenticationService
    {
        Task<string> Register(RegisterRequest request);
        Task<string> Login(LoginRequest request);

    }
}
