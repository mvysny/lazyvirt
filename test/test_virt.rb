require 'minitest/autorun'
require 'virt'

VIRSH_DOMAINS=<<EOF
 Id   Name                 State
-------------------------------------
 5    Flow                 running
 -    BASE                 shut off
 -    win11                shut off
EOF

class TestVirt < Minitest::Test
  def test_domains
    d = VirtCmd.new.domains VIRSH_DOMAINS
    assert_equal '5: Flow: running, -: BASE: shut_off, -: win11: shut_off', d.join(', ')
  end
end

