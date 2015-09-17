OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:instagram] = OmniAuth::AuthHash.new({
  'provider' => 'instagram',
  'uid' => 1,
  'info' => {
    'bio' => 'hello world!',
    'email' => 'user@example.com',
    'name' => 'Test User',
    'nickname' => 'thoughtbot',
    'website' => 'www.rehasism.com',
  }
})
