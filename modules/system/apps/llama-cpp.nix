{ inputs, ... }:
{
  environment.systemPackages = [
    inputs.llama-cpp.packages.x86_64-linux.cuda
  ];
}
