/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    transpilePackages: ['@chainaudit/shared', '@chainaudit/base-adapter', '@chainaudit/stacks-adapter'],
};

export default nextConfig;
