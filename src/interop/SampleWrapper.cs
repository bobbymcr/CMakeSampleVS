namespace Sample.Interop
{
    using System;
    using System.Runtime.InteropServices;
    using Microsoft.Win32.SafeHandles;

    public sealed class SampleWrapper : IDisposable
    {
        private readonly NativeMethods.SampleHandle handle;
        private readonly Lazy<string> name;

        public SampleWrapper(string name)
        {
            this.handle = NativeMethods.SampleInit(name);
            this.name = new Lazy<string>(this.GetName);
        }

        public string Name => this.name.Value;

        public void Dispose()
        {
            if (!this.handle.IsClosed)
            {
                this.handle.Dispose();
            }
        }

        private string GetName()
        {
            IntPtr str = NativeMethods.SampleGetName(this.handle);
            return Marshal.PtrToStringAnsi(str);
        }

        private static class NativeMethods
        {
            private const string Lib = "sample-lib";

            public sealed class SampleHandle : SafeHandleZeroOrMinusOneIsInvalid
            {
                public SampleHandle()
                    : base(true)
                {
                }

                protected override bool ReleaseHandle()
                {
                    SampleDestroy(this.handle);
                    return true;
                }
            }

            [DllImport(Lib)]
            public static extern SampleHandle SampleInit(
                [MarshalAs(UnmanagedType.LPStr)] string name);

            [DllImport(Lib)]
            public static extern IntPtr SampleGetName(SampleHandle p);

            [DllImport(Lib)]
            public static extern void SampleDestroy(IntPtr p);
        }
    }
}
