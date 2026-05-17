using System.Net;
using Microsoft.AspNetCore.Mvc.Testing;

namespace TensorGate.Tests;

public sealed class ProxyHealthTests : IClassFixture<WebApplicationFactory<TensorGate.Proxy.Program>>
{
    private readonly WebApplicationFactory<TensorGate.Proxy.Program> _factory;

    public ProxyHealthTests(WebApplicationFactory<TensorGate.Proxy.Program> factory) => _factory = factory;

    [Fact]
    public async Task Root_ReturnsServiceMetadata()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/");
        response.EnsureSuccessStatusCode();

        var body = await response.Content.ReadAsStringAsync();
        Assert.Contains("TensorGate.Proxy", body, StringComparison.Ordinal);
    }

    [Fact]
    public async Task Health_ReturnsOk()
    {
        var client = _factory.CreateClient();
        var response = await client.GetAsync("/health");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
