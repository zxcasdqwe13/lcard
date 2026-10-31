import contextlib
import io
import tempfile
import unittest
from pathlib import Path

from e440.cli import main


class CliTests(unittest.TestCase):
    def test_selftest(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main(["selftest", "--mock"])
        self.assertEqual(code, 0, output.getvalue())
        self.assertIn("selftest OK", output.getvalue())

    def test_info(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main(["info", "--mock"])
        self.assertEqual(code, 0, output.getvalue())
        self.assertIn("E14-440", output.getvalue())

    def test_acquire_writes_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "adc.bin"
            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = main(
                    [
                        "acquire",
                        "--mock",
                        "--blocks",
                        "1",
                        "--buffer-words",
                        "256",
                        "--channels",
                        "2",
                        "--out",
                        str(out),
                    ]
                )
            self.assertEqual(code, 0, output.getvalue())
            self.assertTrue(out.is_file())
            self.assertEqual(out.stat().st_size, 256 * 2)

    def test_acquire_npy(self):
        try:
            import numpy  # noqa: F401
        except ImportError:
            self.skipTest("numpy is not installed")
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "adc.npy"
            with contextlib.redirect_stdout(io.StringIO()):
                code = main(
                    [
                        "acquire",
                        "--mock",
                        "--blocks",
                        "1",
                        "--buffer-words",
                        "128",
                        "--out",
                        str(out),
                    ]
                )
            self.assertEqual(code, 0)
            self.assertTrue(out.is_file())


if __name__ == "__main__":
    unittest.main()
