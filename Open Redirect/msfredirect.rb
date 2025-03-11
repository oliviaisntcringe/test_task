
require 'msf/core'
class MetasploitModule < Msf::Auxiliary
  include Msf::Exploit::Remote::HttpClient
  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'CORS Redirect Checker',
      'Description'    => %q{
        Проверяет корректность перенаправления на основе заголовка Location.
      },
      'Author'         => ['tuer le prince'],
      'License'        => MSF_LICENSE,
      'References'     => [],
      'DisclosureDate' => '2023-10-01'
    ))

    register_options(
      [
        OptString.new('ALLOWED_DOMAIN', [true, 'Доверенный домен', 'https://ex.rogki.ru']),
        OptString.new('TARGETURL', [true, 'Путь для проверки', '/redir/https://ptsecurity.com'])
      ])
  
  
    end
  def run

    allowed_domain = datastore['ALLOWED_DOMAIN']
    test_url = normalize_uri(datastore['TARGETURL'])

    begin

      res = send_request_cgi({
        'uri'    => test_url,
        'method' => 'GET'
      })
      if res && res.headers['Location']
        location = res.headers['Location']
        if location.start_with?(allowed_domain)
          print_good("Перенаправление корректное: #{location}")
        else
          print_error("Обнаружено некорректное перенаправление: #{location}")
        end
      else
        print_error("Заголовок Location отсутствует в ответе.")
      end
    rescue ::Rex::ConnectionError, ::Timeout::Error => e
      print_error("Ошибка при выполнении запроса: #{e.message}")
    end
  end
end