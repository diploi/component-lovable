import { Button } from "@/components/ui/button";

const Hero = () => {
  return (
    <section className="py-20">
      <div className="container mx-auto px-4 text-center">
        {/* Main heading */}
        <h1 className="text-4xl md:text-5xl font-bold mb-6">
          Build amazing apps in minutes
        </h1>

        {/* Subtitle */}
        <p className="text-xl text-muted-foreground max-w-2xl mx-auto mb-8">
          The fastest way to create beautiful, responsive web applications.
        </p>

        {/* CTA Buttons */}
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <Button size="lg">
            Get Started
          </Button>
          <Button size="lg" variant="outline">
            Learn More
          </Button>
        </div>
      </div>
    </section>
  );
};

export default Hero;