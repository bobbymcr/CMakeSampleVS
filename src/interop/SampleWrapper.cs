namespace Sample.Interop
{
    using System;

    public sealed class SampleWrapper : IDisposable
    {
        public SampleWrapper(string name)
        {
            this.Name = name;
        }

        public string Name { get; private set; }

        public void Dispose()
        {
        }
    }
}
