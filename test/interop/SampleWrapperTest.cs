namespace Sample.Interop.Test
{
    using FluentAssertions;
    using Xunit;

    public sealed class SampleWrapperTest
    {
        [Fact]
        public void GetName()
        {
            using var hello = new SampleWrapper("world");

            hello.Name.Should().Be("world");
        }
    }
}
