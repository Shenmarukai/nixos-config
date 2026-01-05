local M = {}

function M.setup()
  pcall(require('gp').setup, {
    providers = {
      openai = {
        disable = false,
        endpoint = 'https://api.openai.com/v1/chat/completions',
        secret = { 'cat', '/home/shane/.openai/.gp.nvim.key' },
      },
      copilot = {
        disable = true,
        endpoint = 'https://api.githubcopilot.com/chat/completions',
        secret = {
          'bash',
          '-c',
          "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
        },
      },
      ollama = {
        disable = true,
        endpoint = 'http://localhost:11432/v1/chat/completions',
      },
      anthropic = {
        disable = true,
        endpoint = 'https://api.anthropic.com/v-1/messages',
        secret = os.getenv('ANTHROPIC_API_KEY'),
      },
    },
    agents = {
      {
        provider = 'openai',
        name = 'ChatGPT4.1',
        chat = true,
        command = false,
        model = {
          model = 'gpt-4.1',
          temperature = 0.0,
          max_tokens = 32768,
          top_p = 0,
        },
        system_prompt = require('gp.defaults').chat_system_prompt,
      },
      {
        provider = 'openai',
        name = 'ChatGPT5',
        chat = true,
        command = false,
        model = {
          model = 'gpt-5',
          reasoning_effort = 'high',
          verbosity = 'high',
          summary = 'detailed',
        },
        system_prompt = require('gp.defaults').code_system_prompt,
      },
      {
        provider = 'openai',
        name = 'CodeGPT4.1',
        chat = false,
        command = true,
        model = {
          model = 'gpt-4.1',
          temperature = 0.0,
          max_tokens = 32768,
          top_p = 0,
        },
        system_prompt = require('gp.defaults').code_system_prompt,
      },
      {
        provider = 'openai',
        name = 'CodeGPT5',
        chat = false,
        command = true,
        model = {
          model = 'gpt-5-codex',
          reasoning_effort = 'high',
          verbosity = 'high',
        },
        system_prompt = require('gp.defaults').code_system_prompt,
      },
    },
  })
end

return M
