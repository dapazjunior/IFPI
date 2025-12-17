import pytest
from modelos import ModalidadePadrao, ModalidadeLuxo, Veiculo


def test_modalidade_padrao_calculo():
    servico = ModalidadePadrao(5, 2, 1.0)
    valor = servico.calcular_valor_corrida(10, 10)

    assert valor > 0
    assert isinstance(valor, float)


def test_modalidade_luxo_calculo():
    servico = ModalidadeLuxo(5, 2, 1.0, 10)
    valor = servico.calcular_valor_corrida(10, 10)

    assert valor > 0
    assert valor > 30


def test_veiculo_sem_servico():
    veiculo = Veiculo("AAA-0000", "Uno")

    with pytest.raises(Exception):
        veiculo.realizar_corrida(5, 10)


def test_veiculo_sem_servico():
    veiculo = Veiculo("AAA-0000", "Uno")

    with pytest.raises(Exception):
        veiculo.realizar_corrida(5, 10)


def test_valores_invalidos():
    servico = ModalidadePadrao(5, 2, 1.0)

    with pytest.raises(ValueError):
        servico.calcular_valor_corrida(-1, 5)


def test_veiculo_com_servico_associado():
    from modelos import ModalidadePadrao, Veiculo

    servico = ModalidadePadrao(5, 2, 1.0)
    veiculo = Veiculo("AAA-1234", "Celta")

    veiculo.associar_servico(servico)

    assert veiculo.servico_associado is servico


def test_polimorfismo_padrao_vs_luxo():
    from modelos import ModalidadePadrao, ModalidadeLuxo

    padrao = ModalidadePadrao(5, 2, 1.0)
    luxo = ModalidadeLuxo(5, 2, 1.0, 10)

    valor_padrao = padrao.calcular_valor_corrida(10, 10)
    valor_luxo = luxo.calcular_valor_corrida(10, 10)

    assert valor_luxo > valor_padrao


def test_registro_corrida():
    from modelos import ModalidadePadrao, Veiculo, Corrida

    servico = ModalidadePadrao(5, 2, 1.0)
    veiculo = Veiculo("BBB-9999", "Uno")
    veiculo.associar_servico(servico)

    corrida = Corrida(veiculo, 5, 10)
    corrida.registrar_corrida()

    assert corrida.valor_total_pago is not None


def test_plataforma_adicionar_veiculo():
    from plataforma import PlataformaDeTransporte
    from modelos import Veiculo

    plataforma = PlataformaDeTransporte()
    veiculo = Veiculo("CCC-0000", "Gol")

    plataforma.adicionar_veiculo(veiculo)

    assert veiculo in plataforma.listar_veiculos()


def test_faturamento_diario():
    from plataforma import PlataformaDeTransporte
    from modelos import ModalidadePadrao, Veiculo

    plataforma = PlataformaDeTransporte()
    servico = ModalidadePadrao(5, 2, 1.0)

    veiculo = Veiculo("DDD-1111", "HB20")
    veiculo.associar_servico(servico)

    plataforma.adicionar_veiculo(veiculo)
    plataforma.registrar_corrida(veiculo, 5, 10)

    total = plataforma.resumo_faturamento_diario()

    assert total > 0


def test_tempo_invalido():
    from modelos import ModalidadePadrao

    servico = ModalidadePadrao(5, 2, 1.0)

    with pytest.raises(ValueError):
        servico.calcular_valor_corrida(5, 0)